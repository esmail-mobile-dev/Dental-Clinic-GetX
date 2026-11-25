import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysen/core/approut.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/error.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/appointment_controller.dart';
import 'package:mysen/features/doctor/controller/treatment_controller.dart';
import 'package:mysen/features/doctor/services/doctorservices.dart';
import 'package:mysen/features/patients/services/patientsservices.dart';
import 'package:mysen/features/shared/model/appointment.dart';
import 'package:mysen/features/shared/model/doctor.dart';
import 'package:mysen/features/shared/model/doctor_pateint.dart';
import 'package:mysen/features/shared/model/patients.dart';
import 'package:mysen/features/shared/model/patientsfordoctor.dart';
import 'package:mysen/features/shared/model/request_reservation.dart';
import 'package:mysen/features/shared/model/treatment_case.dart';
import 'package:mysen/features/shared/services/appointmentservices.dart';
import 'package:mysen/features/shared/services/doctorpatientservices.dart';
import 'package:mysen/features/shared/services/requsetreserveservices.dart';
import 'package:mysen/features/shared/services/sharedprefrenceservice.dart';
import 'package:mysen/features/shared/services/sql.dart';
import 'package:mysen/features/shared/services/treatmentcaseservices.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Doctorcontroller extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController nickNamecontroller = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  //services
  Doctorservices doctorservices = Doctorservices();
  Doctorpatientservices doctorpatientservices = Doctorpatientservices();
  Appointmentservices appointmentservices = Appointmentservices();
  Treatmentcaseservices treatmentcaseservices = Treatmentcaseservices();
  Patientsservices patientsservices = Patientsservices();
  Requstreserveservices requstreserveservices = Requstreserveservices();

  //list
  final RxList<Patientsfordoctor> _patientsfordoctor =
      <Patientsfordoctor>[].obs;
  RxList<Patientsfordoctor> get patientsfordoctor =>
      _patientsfordoctor.reversed.toList().obs;

  final RxList<Requestreservation> _requestRservation =
      <Requestreservation>[].obs;
  RxList<Requestreservation> get requestRservation => _requestRservation;
  RxList<Requestreservation> get requestRservationForNotfication =>
      _requestRservation
          .where((p0) => p0.stateRequest == StateRequest.waiting)
          .toList()
          .obs;

  final GlobalKey<FormState> formKey = GlobalKey();

  late final RealtimeChannel channel;
  RxBool isLoading = false.obs;
  RxBool isFetchRequest = false.obs;

  // variable

  RxBool isSearch = false.obs;
  RxString doctorfullName = ''.obs;
  Doctor? doctor;
  Patient get patient => Patient(
    fullName:
        ('${nameController.text.trim()} ${nickNamecontroller.text.trim()}')
            .replaceAll(RegExp(r'\s+'), ' '),

    phone: phoneController.text,
  );
  DatabaseHelper sql = DatabaseHelper.instance;
  late InternetService internetService;
  StreamSubscription<bool>? subscription;
  final sharedPref = Get.find<SharedPrefService>();
  // functions

  // doctor
  Future<void> fetchDoctorByUserID() async {
    try {
      final userID = client.auth.currentUser?.id;
      final dsql = await sql.queryAll('doctor');
      if (dsql.isNotEmpty) {
        doctor = Doctor.fromMapSql(dsql.first);
        setDoctorNAme();
        return;
      }
      if (!await internetService.checkNow() || userID == null) {
        return;
      }

      final response = await doctorservices
          .fetchDoctorByUserID(userID)
          .timeout(const Duration(seconds: duration15));
      doctor = response != null ? Doctor.fromMap(response) : null;

      if (doctor == null) {
        return;
      }

      setDoctorNAme();
      await sql.insert('doctor', doctor!.toMapSql());
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (_) {
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    }
  }

  setDoctorNAme() {
    if (doctor == null) {
      return;
    }
    final name = doctor?.fullName.split(' ').sublist(0, 2).join(' ');
    final lastName = doctor?.fullName.split(' ').last;
    doctorfullName.value = '$name$lastName';
  }

  // patients
  Future<void> loadPatientFromSql() async {
    _patientsfordoctor.clear();

    final patientsSql = await sql.queryAll('patientsForDoctor');
    _patientsfordoctor.assignAll(
      patientsSql.map((e) => Patientsfordoctor.fromMapSql(e)),
    );
  }

  Future<void> fetchPatientsForDoctor() async {
    try {
      loadPatientFromSql();

      if (!await internetService.checkNow()) {
        return;
      }
      final patientsSql = await sql.queryAll('patientsForDoctor');

      if (patientsSql.isEmpty) {
        final patients = await doctorpatientservices
            .fetchPatients()
            .order('createdAt', ascending: true)
            .timeout(const Duration(seconds: duration15));

        _patientsfordoctor.assignAll(
          patients.map((p) => Patientsfordoctor.fromMap(p)),
        );
        for (var p in _patientsfordoctor) {
          await sql.insert('patientsForDoctor', p.toMapSql());
        }
      }
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (_) {
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    }
  }

  Future<void> addPatientForDoctor() async {
    try {
      if (!formKey.currentState!.validate()) return;
      if (!await internetService.checkNow()) {
        ErrorHndel.handleError(ErrorType.internet);
        return;
      }
      if (_patientsfordoctor.any((e) => e.phone == patient.phone)) {
        MessageHandle.handleMessage(MessageType.patientExist);

        return;
      }

      isLoading.value = true;

      final patientexist = await patientsservices
          .fetchPatientByPhone(patient.phone)
          .timeout(const Duration(seconds: duration15));
      if (patientexist != null) {
        final dp = DoctorPateint(
          doctorID: doctor!.id!,
          patientID: patientexist['id'],
          isDeletePatient: patientexist['userID'] == null,
        );

        final doctorPatient = await doctorpatientservices
            .upsertDoctorPatient(dp)
            .select("id")
            .single();

        await sql.insert(
          'patientsForDoctor',
          Patientsfordoctor(
            id: doctorPatient['id'],
            patientID: patientexist['id'],
            fullName: patientexist['fullName'],
            phone: patientexist['phone'],
          ).toMapSql(),
        );
        final treatment = await treatmentcaseservices.fetchTreatmentCaseBydpID(
          doctorPatient['id'],
        );
        for (var tr in treatment) {
          await sql.insert(
            'treatmentCase',
            TreatmentCase.fromMap(tr).toMapSql(),
          );
        }
        final app = await appointmentservices.fetchAppointmentBydpID(
          doctorPatient['id'],
        );
        for (var appointment in app) {
          await sql.insert(
            'appointment',
            Appointment.fromMap(appointment).toMapSql(),
          );
        }
        clearController();
        back();
        MessageHandle.handleMessage(MessageType.add);

        return;
      }

      final patientAdd = await patientsservices
          .addPatient(patient)
          .select()
          .single()
          .timeout(const Duration(seconds: duration15));

      final dp = DoctorPateint(
        doctorID: doctor!.id!,
        patientID: patientAdd['id'],
        isDeletePatient: patientAdd['userID'] == null,
      );
      final dpFetch = await doctorpatientservices
          .upsertDoctorPatient(dp)
          .select("id")
          .single()
          .timeout(const Duration(seconds: duration15));
      await sql.insert(
        'patientsForDoctor',
        Patientsfordoctor(
          id: dpFetch['id'],
          patientID: dp.patientID,
          fullName: patient.fullName,
          phone: patient.phone,
        ).toMapSql(),
      );
      clearController();
      back();
      MessageHandle.handleMessage(MessageType.add);
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (e) {
      if (e.code == '42501') {
        ErrorHndel.handleError(ErrorType.rls);
      }
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {
      isLoading.value = false;
      loadPatientFromSql();
    }
  }

  Future<void> deletePatintForDoctor(String id) async {
    try {
      isLoading.value = true;
      if (!await internetService.checkNow()) {
        ErrorHndel.handleError(ErrorType.internet);

        return;
      }

      await client.rpc(
        'delete_doctor_patient',
        params: {'p_id': id, 'p_is_doctor': true},
      );
      await sql.delete('patientsForDoctor', id);
      back();

      MessageHandle.handleMessage(MessageType.delete);
      return;
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (_) {
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {
      isLoading.value = false;
      loadPatientFromSql();
    }
  }

  void loadRequestFromSql() async {
    final r = await sql.queryAll('request');

    _requestRservation.assignAll(
      r.map((e) => Requestreservation.fromMapsql(e)),
    );
  }

  Future<void> fetchRequest() async {
    try {
      final requestsSql = await sql.queryAll('request');
      if (!await internetService.checkNow()) {
        return;
      }
      final request = await requstreserveservices
          .fetchRequstReserve()
          .order('sendTime')
          .timeout(const Duration(seconds: duration15));

      _requestRservation.assignAll(
        request.map((e) => Requestreservation.fromMap(e)),
      );

      for (var r in requestsSql) {
        await sql.delete('request', r['id']);
      }

      for (var r in _requestRservation) {
        await sql.insert('request', r.toMapsql());
      }
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (_) {
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {
      loadRequestFromSql();
    }
  }

  void clearController() {
    nameController.clear();
    nickNamecontroller.clear();
    phoneController.clear();
  }

  Future<void> sigOut() async {
    if (!await internetService.checkNow()) {
      ErrorHndel.handleError(ErrorType.internet);

      return;
    }
    await sql.deleteDatabaseFile();
    await sharedPref.removeRole();
    Get.offAllNamed(Approut.log);
  }

  changelanguage(String lang) {
    Get.updateLocale(Locale(lang));
    sharedPref.setLang(lang);
    back();
  }

  void back() {
    if (Get.isOverlaysOpen || Get.key.currentState?.canPop() == true) {
      Get.back();
    }
  }

  void rout(String page) {
    Get.toNamed(page);
  }

  Future<void> changeTheme(int index) async {
    await sharedPref.setTheme(Utils.listTheme[index]['name']);
    if (Get.isOverlaysOpen || Get.key.currentState?.canPop() == true) {
      Get.back();
      MessageHandle.handleMessage(MessageType.applyTheme);
    }
  }

  void filterPatient(Patientsfordoctor p) {
    _patientsfordoctor.removeWhere((element) => element.id == p.id);
    _patientsfordoctor.add(p);
  }

  Future<void> fetchAll() async {
    await fetchDoctorByUserID();
    if (doctor == null) {
      ErrorHndel.handleError(ErrorType.error);
      isLoading.value = false;
      return;
    }
    await fetchPatientsForDoctor();
    await fetchRequest();
    isLoading.value = false;
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      internetService = InternetService();
      Get.lazyPut(() => AppointmentController(), fenix: true);
      Get.lazyPut(() => TreatmentController(), fenix: true);
      fetchAll();
      channel = Utils.setupRealtimeChannel(
        tableName: 'requestreservation',
        onInsert: (payload) async {
          await fetchRequest();
        },
        onUpdate: (payload) async {
          await fetchRequest();
        },
      );

      subscription = internetService.onStatusChange.listen((hasInternet) {});
    });

    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    nickNamecontroller.dispose();
    phoneController.dispose();
    client.removeChannel(channel);
    internetService.dispose();
    subscription?.cancel();
    super.onClose();
  }
}
