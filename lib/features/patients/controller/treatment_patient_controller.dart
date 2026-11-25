import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/error.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/shared/model/appointment.dart';
import 'package:mysen/features/shared/model/treatment_case.dart';
import 'package:mysen/features/shared/services/appointmentservices.dart';
import 'package:mysen/features/shared/services/sharedprefrenceservice.dart';
import 'package:mysen/features/shared/services/sql.dart';
import 'package:mysen/features/shared/services/treatmentcaseservices.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TreatmentPatientController extends GetxController {
  RxBool isLoading = false.obs;
  final RxList<Appointment> _appointments = <Appointment>[].obs;
  RxList<Appointment> get appointments => _appointments;
  final RxList<TreatmentCase> _treatmentCase = <TreatmentCase>[].obs;
  RxList<TreatmentCase> get treatmentCase => _treatmentCase;

  Appointmentservices appointmentservices = Appointmentservices();
  Treatmentcaseservices treatmentcaseservices = Treatmentcaseservices();

  final sharedPref = Get.find<SharedPrefService>();
  DatabaseHelper sql = DatabaseHelper.instance;

  late InternetService internetService;

  int payPaid(TreatmentCase treatment) {
    int paypaid = 0;
    for (var app in _appointments.where(
      (p0) => p0.treatmentCaseID == treatment.id,
    )) {
      paypaid = paypaid + app.payPrice;
    }

    return paypaid;
  }

  RxList<Appointment> appointmentsLeading(TreatmentCase treatment) {
    return appointments
        .where((p0) => p0.treatmentCaseID == treatment.id)
        .toList()
        .obs;
  }

  Future<void> loadTreatmentCaseFromSql() async {
    _treatmentCase.clear();
    final treatmentCaseSql = await sql.queryAll('treatmentCaseP');

    _treatmentCase.assignAll(
      treatmentCaseSql.map((a) => TreatmentCase.fromMapSql(a)),
    );
  }

  Future<void> fetchTreatmentCase() async {
    try {
      final treatmentCaseSql = await sql.queryAll('treatmentCaseP');

      if (!await internetService.checkNow()) {
        return;
      }
      isLoading.value = true;

      final treatment = await treatmentcaseservices
          .fetchTreatmentCase()
          .order('createdAt', ascending: true)
          .timeout(const Duration(seconds: duration15));
      _treatmentCase.assignAll(treatment.map((a) => TreatmentCase.fromMap(a)));

      for (var tr in treatmentCaseSql) {
        await sql.delete('treatmentCaseP', tr['id']);
      }
      for (var tr in _treatmentCase) {
        await sql.insert('treatmentCaseP', tr.toMapSql());
      }
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (_) {
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {
      loadTreatmentCaseFromSql();
      isLoading.value = false;
    }
  }

  Future<void> loadAppointmentFromSql() async {
    _appointments.clear();
    final appointmentSql = await sql.queryAll('appointmentP');
    _appointments.assignAll(
      appointmentSql.map((e) => Appointment.fromMapSql(e)),
    );
  }

  Future<void> fetchAppointMent() async {
    try {
      final appintmentsql = await sql.queryAll('appointmentP');
      if (!await internetService.checkNow()) {
        return;
      }

      final fetchappointments = await appointmentservices
          .fetchAppointment()
          .order('createdAt', ascending: true)
          .timeout(const Duration(seconds: duration15));
      _appointments.assignAll(
        fetchappointments.map((e) => Appointment.fromMap(e)),
      );
      for (var app in appintmentsql) {
        await sql.delete('appointmentP', app['id']);
      }
      for (var app in _appointments) {
        await sql.insert('appointmentP', app.toMapSql());
      }
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (_) {
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {
      loadAppointmentFromSql();
    }
  }

  void back() {
    if (Get.isOverlaysOpen || Get.key.currentState?.canPop() == true) {
      Get.back();
    }
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
    final teeths = _appointments
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

  Future<void> fetchALl() async {
    await fetchTreatmentCase();
    await fetchAppointMent();
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      internetService = InternetService();
      fetchALl();
    });
    super.onInit();
  }

  @override
  void onClose() {
    internetService.dispose();
    super.onClose();
  }
}
