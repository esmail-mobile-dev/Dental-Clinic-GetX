import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mysen/core/approut.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/error.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/patients/services/patientsservices.dart';
import 'package:mysen/features/shared/model/doctorforpatient.dart';
import 'package:mysen/features/shared/model/patients.dart';
import 'package:mysen/features/shared/services/doctorpatientservices.dart';
import 'package:mysen/features/shared/services/sharedprefrenceservice.dart';
import 'package:mysen/features/shared/services/sql.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Reservationcontroller extends GetxController {
  RxBool isLoading = false.obs;
  bool isrefresh = true;

  final RxList<Doctorforpatient> _doctorsforpatient = <Doctorforpatient>[].obs;
  RxList<Doctorforpatient> get doctorsforpatient => _doctorsforpatient;

  Doctorpatientservices doctorpatientservices = Doctorpatientservices();
  Patientsservices patientsservices = Patientsservices();

  Patient? patient;
  DatabaseHelper sql = DatabaseHelper.instance;
  late InternetService internetService;
  final sharedPref = Get.find<SharedPrefService>();
  late final RealtimeChannel channel;

  Future<void> fetchDoctorsForPatient() async {
    try {
      final dpsql = await sql.queryAll('doctorsForPatient');
      if (!await internetService.checkNow()) {
        _doctorsforpatient.assignAll(
          dpsql.map((e) => Doctorforpatient.fromMapsql(e)),
        );
        return;
      }

      final doctors = await doctorpatientservices
          .fetchDoctors()
          .order('createdAt', ascending: true)
          .timeout(const Duration(seconds: duration15));

      _doctorsforpatient.assignAll(
        doctors.map((doc) => Doctorforpatient.fromMap(doc)),
      );

      for (var dp in dpsql) {
        await sql.delete('doctorsForPatient', dp['id']);
      }
      for (var dp in _doctorsforpatient) {
        await sql.insert('doctorsForPatient', dp.toMapsql());
      }
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (_) {
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    }
  }

  Future<void> deleteDoctorForPatient(
    Doctorforpatient doctorsforpatient,
  ) async {
    try {
      isLoading.value = true;
      if (!await internetService.checkNow()) {
        ErrorHndel.handleError(ErrorType.internet);
        return;
      }

      await client.rpc(
        'delete_doctor_patient',
        params: {'p_id': doctorsforpatient.id, 'p_is_doctor': false},
      );

      await sql.delete('doctorsForPatient', doctorsforpatient.id);
      _doctorsforpatient.removeWhere(
        (element) => element.id == doctorsforpatient.id,
      );
      MessageHandle.handleMessage(MessageType.delete);
      return;
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (_) {
      ErrorHndel.handleError(ErrorType.error);
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPatient() async {
    try {
      final p = await sql.queryAll('patient');
      patient = Patient.fromMapsql(p.first);
    } catch (e) {
      return;
    }
  }

  Future<void> sigOut() async {
    if (!await internetService.checkNow()) {
      ErrorHndel.handleError(ErrorType.internet);

      return;
    }
    Get.offAllNamed(Approut.log);
    sql.deleteDatabaseFile();
    sharedPref.removeRole();
  }

  void changelanguage(String lang) {
    Get.updateLocale(Locale(lang));
    sharedPref.setLang(lang);
    back();
  }

  Future<void> fetchAll() async {
    isLoading.value = true;
    await fetchPatient();
    await fetchDoctorsForPatient();

    isLoading.value = false;
  }

  Future<void> refreshAll() async {
    if (!await internetService.checkNow()) {
      ErrorHndel.handleError(ErrorType.internet);

      return;
    }
    if (isrefresh) {
      fetchAll();
      isrefresh = false;
      Future.delayed(const Duration(minutes: 1), () {
        isrefresh = true;
      });
      return;
    }
    MessageHandle.handleMessage(MessageType.refreshDoctorPatient);
  }

  Future<void> changeTheme(int index) async {
    await sharedPref.setTheme(Utils.listTheme[index]['name']);
    back();
    MessageHandle.handleMessage(MessageType.applyTheme);
  }

  void back() {
    if (Get.isOverlaysOpen || Get.key.currentState?.canPop() == true) {
      Get.back();
    }
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      internetService = InternetService();
      fetchAll();
    });
    internetService = InternetService();
    channel = Utils.setupRealtimeChannel(
      tableName: 'doctorpateint',

      onInsert: (payload) async {
        fetchAll();
      },

      onUpdate: (payload) async {
        fetchAll();
      },
    );

    super.onInit();
  }

  @override
  void onClose() {
    internetService.dispose();
    client.removeChannel(channel);
    super.onClose();
  }
}
