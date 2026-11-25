import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/error.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/doctorcontroller.dart';
import 'package:mysen/features/doctor/controller/treatment_controller.dart';
import 'package:mysen/features/shared/model/appointment.dart';
import 'package:mysen/features/shared/model/appointmentWithPatient.dart';
import 'package:mysen/features/shared/model/patientsfordoctor.dart';
import 'package:mysen/features/shared/model/request_reservation.dart';
import 'package:mysen/features/shared/model/treatment_case.dart';
import 'package:mysen/features/shared/services/appointmentservices.dart';
import 'package:mysen/features/shared/services/sharedprefrenceservice.dart';
import 'package:mysen/features/shared/services/sql.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentController extends GetxController {
  //textcontroller
  TextEditingController payPrice = TextEditingController();
  TextEditingController descruptionController = TextEditingController();

  Appointmentservices appointmentservices = Appointmentservices();

  final RxList<Appointment> _appointMents = <Appointment>[].obs;
  RxList<Appointment> get appointMents => _appointMents;

  final TreatmentController treatmentController = Get.find();
  final Doctorcontroller doctorcontroller = Get.find();

  RxList<Map> teethAdd = <Map>[].obs;
  RxList<Map> teeth = <Map>[].obs;
  RxBool isLoading = false.obs;

  // globalKey
  final GlobalKey<FormState> formKeyAppointment = GlobalKey();
  DatabaseHelper sql = DatabaseHelper.instance;
  late InternetService internetService;
  final sharedPref = Get.find<SharedPrefService>();
  RxInt remainingPrice = 0.obs;
  Rx<DateTime> dateTimeAppointemnt = DateTime.now().obs;
  Rx<DateTime> dateTimeAppointemntDays = DateTime(0, 0, 0, 0).obs;

  RxList<Appointment> appointMentsTreatemnt(TreatmentCase treatment) {
    return _appointMents
        .where((p0) => p0.treatmentCaseID == treatment.id)
        .toList()
        .obs;
  }

  setRemainingPric(int total, int payPaid) {
    if (payPrice.text.isNotEmpty) {
      remainingPrice.value = 0;
      remainingPrice.value = (total - payPaid - int.parse(payPrice.text));
    } else {
      remainingPrice.value = (total - payPaid);
    }
  }

  setTime(TimeOfDay time) {
    dateTimeAppointemnt.value = DateTime(
      dateTimeAppointemnt.value.year,
      dateTimeAppointemnt.value.month,
      dateTimeAppointemnt.value.day,
      time.hour,
      time.minute,
    );
  }

  setDate(DateTime date) {
    dateTimeAppointemnt.value = DateTime(
      date.year,
      date.month,
      date.day,
      dateTimeAppointemnt.value.hour,
      dateTimeAppointemnt.value.minute,
    );
  }

  setDateDays(DateTime date) {
    dateTimeAppointemntDays.value = DateTime(
      date.year,
      date.month,
      date.day,
      dateTimeAppointemntDays.value.hour,
      dateTimeAppointemntDays.value.minute,
    );
  }

  int payPaid(TreatmentCase treatment) {
    int paypaid = 0;
    for (var app in _appointMents.where(
      (p0) => p0.treatmentCaseID == treatment.id,
    )) {
      paypaid = paypaid + app.payPrice;
    }

    return paypaid;
  }

  Future<void> loadAppointmentFromSql() async {
    _appointMents.clear();
    final appointmentSql = await sql.queryAll('appointment');
    for (var app in appointmentSql) {
      _appointMents.add(Appointment.fromMapSql(app));
    }
  }

  Future<void> fetchAppointMent() async {
    try {
      final appointmentSql = await sql.queryAll('appointment');
      loadAppointmentFromSql();
      if (!await internetService.checkNow()) {
        return;
      }

      if (appointmentSql.isEmpty) {
        isLoading.value = true;
        final app = await appointmentservices
            .fetchAppointment()
            .order('createdAt', ascending: true)
            .timeout(const Duration(seconds: duration15));
        _appointMents.assignAll(app.map((a) => Appointment.fromMap(a)));

        for (var ap in _appointMents) {
          await sql.insert('appointment', ap.toMapSql());
        }
      }
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (_) {
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {
      isLoading.value = false;
    }
  }

  RxList<Appointmentwithpatient> fetchAllReserv(DateTime datTime) {
    final List<Patientsfordoctor> patients = doctorcontroller.patientsfordoctor;
    final List<Requestreservation> requests = doctorcontroller.requestRservation
        .where((p0) => p0.stateRequest == StateRequest.accepted)
        .toList();

    final RxList<Appointmentwithpatient> result =
        <Appointmentwithpatient>[].obs;
    for (var r in requests) {
      if (r.reciveTime != null) {
        final isSameDate =
            r.reciveTime?.year == datTime.year &&
            r.reciveTime?.month == datTime.month &&
            r.reciveTime?.day == datTime.day;
        if (!isSameDate) continue;
        result.add(
          Appointmentwithpatient(
            appointment: Appointment(
              treatmentCaseID: '',
              timeAppointment: r.reciveTime!,
              payPrice: 0,
            ),
            patientName: r.patientName,
          ),
        );
      }
    }
    for (var appointment in _appointMents) {
      final appoimentDate = appointment.timeAppointment;
      final isSameDate =
          appoimentDate.year == datTime.year &&
          appoimentDate.month == datTime.month &&
          appoimentDate.day == datTime.day;
      if (!isSameDate) continue;

      final treatment = treatmentController.treatmentCaseActive
          .firstWhereOrNull(
            (element) => element.id == appointment.treatmentCaseID,
          );
      if (treatment == null) continue;

      final patient = patients.firstWhereOrNull(
        (element) => element.id == treatment.doctorPatientID,
      );
      if (patient == null) continue;
      result.add(
        Appointmentwithpatient(
          appointment: appointment,
          patientName: patient.fullName,
        ),
      );
    }

    return result;
  }

  Future<void> addAppointment(String treatmentCaseID) async {
    try {
      if (!formKeyAppointment.currentState!.validate()) {
        return;
      }
      if (!await internetService.checkNow()) {
        ErrorHndel.handleError(ErrorType.internet);

        return;
      }

      final appointment = Appointment(
        timeAppointment: dateTimeAppointemnt.value,
        payPrice: int.parse(payPrice.text.trim()),
        treatmentCaseID: treatmentCaseID,
        teethSelected: teeth,
      );

      isLoading.value = true;
      final app = await appointmentservices
          .addAppointment(appointment)
          .timeout(const Duration(seconds: duration15));

      await sql.insert(
        'appointment',
        appointment.copyWith(id: app['id']).toMapSql(),
      );

      loadAppointmentFromSql();
      clearAppointmentController();

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
    }
  }

  void addDescription(int index) {
    if (descruptionController.text.isNotEmpty) {
      teethAdd[index]['description'] = descruptionController.text;
      descruptionController.clear();
    }
    back();
  }

  void addTeethAdd() {
    teeth.assignAll(teethAdd);

    back();
  }

  void onChangeSelectTeeth(List<String> teethSelect) {
    for (var number in teethSelect) {
      final isExist = teethAdd.any((element) => element['number'] == number);
      if (!isExist) {
        teethAdd.add({'number': number, "description": 'empty'.tr});
      }
    }
    teethAdd.removeWhere((element) => !teethSelect.contains(element['number']));
  }

  List<String> initiallySelectedTeeth() {
    final List<String> number = teethAdd
        .map((element) => element['number'] as String)
        .toList();
    return number;
  }

  Map<String, Color> colorized(List<Map>? teeth) {
    final Map<String, Color> map = {};
    if (teeth == null) {
      return {};
    }
    for (var t in teeth) {
      map.addAll({t['number']: whitecolor});
    }
    return map;
  }

  List<Map<String, Color>> colorizedLeading(String trID) {
    final teeths = appointMents
        .where((p0) => p0.treatmentCaseID == trID)
        .map((element) => element.teethSelected);
    final List<Map<String, Color>> listmap = [];
    for (var teeth in teeths) {
      if (teeth == null) {
        return [];
      }
      final Map<String, Color> map = {};
      for (var t in teeth) {
        map.addAll({t['number']: whitecolor});
      }
      listmap.add(map);
    }
    return listmap;
  }

  void clearAppointmentController() {
    remainingPrice.value = 0;
    dateTimeAppointemnt.value = DateTime.now();
    payPrice.clear();
    teethAdd.clear();
    teeth.clear();
    descruptionController.clear();
  }

  void back() {
    if (Get.isOverlaysOpen || Get.key.currentState?.canPop() == true) {
      Get.back();
    }
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchAppointMent();

      internetService = InternetService();
    });

    super.onInit();
  }

  @override
  void onClose() {
    internetService.dispose();
    payPrice.dispose();
    descruptionController.dispose();
    super.onClose();
  }
}
