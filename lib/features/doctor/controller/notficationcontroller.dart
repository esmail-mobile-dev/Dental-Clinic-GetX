import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/error.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/doctorcontroller.dart';
import 'package:mysen/features/patients/services/patientsservices.dart';
import 'package:mysen/features/shared/model/appointment.dart';
import 'package:mysen/features/shared/model/doctor_pateint.dart';
import 'package:mysen/features/shared/model/patientsfordoctor.dart';
import 'package:mysen/features/shared/model/request_reservation.dart';
import 'package:mysen/features/shared/model/treatment_case.dart';
import 'package:mysen/features/shared/services/appointmentservices.dart';
import 'package:mysen/features/shared/services/doctorpatientservices.dart';
import 'package:mysen/features/shared/services/requsetreserveservices.dart';
import 'package:mysen/features/shared/services/treatmentcaseservices.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Notficationcontroller extends GetxController {
  final Doctorcontroller doctorcontroller = Get.find();

  RxBool isLoading = false.obs;
  bool isfetch = true;

  Requstreserveservices requstreserveservices = Requstreserveservices();
  Patientsservices patientsservices = Patientsservices();
  Doctorpatientservices doctorpatientservices = Doctorpatientservices();
  Appointmentservices appointmentservices = Appointmentservices();
  Treatmentcaseservices treatmentcaseservices = Treatmentcaseservices();

  Rx<DateTime> dateTimeAppointemnt = DateTime.now().obs;

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

  Future<void> addPatientForDoctorFromRequest(
    Requestreservation request,
  ) async {
    try {
      final dp = DoctorPateint(
        doctorID: request.doctorID,
        patientID: request.patientID,
      );
      final doctorPatient = await doctorpatientservices
          .upsertDoctorPatient(dp)
          .select("id")
          .single();

      await doctorcontroller.sql.insert(
        'patientsForDoctor',
        Patientsfordoctor(
          id: doctorPatient['id'],
          patientID: request.patientID,
          fullName: request.patientName,
          phone: request.phone,
        ).toMapSql(),
      );
      final treatment = await treatmentcaseservices.fetchTreatmentCaseBydpID(
        doctorPatient['id'],
      );
      for (var tr in treatment) {
        await doctorcontroller.sql.insert(
          'treatmentCase',
          TreatmentCase.fromMap(tr).toMapSql(),
        );
      }
      final app = await appointmentservices.fetchAppointmentBydpID(
        doctorPatient['id'],
      );
      for (var appointment in app) {
        await doctorcontroller.sql.insert(
          'appointment',
          Appointment.fromMap(appointment).toMapSql(),
        );
      }
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (_) {
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {}
  }

  Future<void> updatePatientForDoctorFromRequest(
    Requestreservation request,
  ) async {
    try {
      await doctorpatientservices
          .updateIsDeletePatient(request.patientID)
          .timeout(const Duration(seconds: duration15));

      doctorcontroller.loadPatientFromSql();
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (_) {
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {}
  }

  Future<void> updateRequest(
    Requestreservation requestreservation,

    StateRequest stateRequest,
  ) async {
    try {
      await requstreserveservices
          .updateRequest(
            requestreservation.copyWith(
              stateRequest: stateRequest,
              reciveTime: stateRequest == StateRequest.reject
                  ? null
                  : dateTimeAppointemnt.value,
            ),
          )
          .timeout(const Duration(seconds: duration15));
      back();
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (_) {
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {}
  }

  Future<void> accept(Requestreservation request) async {
    if (!await doctorcontroller.internetService.checkNow()) {
      ErrorHndel.handleError(ErrorType.internet);

      return;
    }
    final ispatientExist = doctorcontroller.patientsfordoctor.any(
      (element) => element.patientID == request.patientID,
    );

    try {
      isLoading.value = true;

      if (ispatientExist) {
        await updatePatientForDoctorFromRequest(request);
        await updateRequest(request, StateRequest.accepted);
        MessageHandle.handleMessage(MessageType.add);

        return;
      }

      await addPatientForDoctorFromRequest(request);
      await updateRequest(request, StateRequest.accepted);
      doctorcontroller.loadPatientFromSql();
      MessageHandle.handleMessage(MessageType.add);
      return;
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void reject(Requestreservation request) async {
    if (!await doctorcontroller.internetService.checkNow()) {
      ErrorHndel.handleError(ErrorType.internet);

      return;
    }
    try {
      isLoading.value = true;
      await updateRequest(request, StateRequest.reject);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRequest() async {
    if (!await doctorcontroller.internetService.checkNow()) {
      ErrorHndel.handleError(ErrorType.internet);

      return;
    }

    await doctorcontroller.fetchRequest();
    isfetch = false;
    Future.delayed(const Duration(seconds: 30), () {
      isfetch = true;
    });
  }

  void back() {
    if (Get.isOverlaysOpen || Get.key.currentState?.canPop() == true) {
      Get.back();
    }
  }
}
