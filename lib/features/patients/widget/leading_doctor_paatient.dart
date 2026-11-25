import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:mysen/features/patients/controller/main_screen_ccontroller.dart';
import 'package:mysen/features/patients/controller/treatment_patient_controller.dart';
import 'package:mysen/features/shared/model/appointment.dart';
import 'package:mysen/features/shared/model/doctorforpatient.dart';
import 'package:mysen/features/shared/widget/appointment_list.dart';

class LeadingDoctorPatient extends StatelessWidget {
  const LeadingDoctorPatient({
    super.key,
    required this.dp,
    required this.treatmentPatientController,
    required this.mainscreeniccontroller,
  });

  final Doctorforpatient dp;
  final TreatmentPatientController treatmentPatientController;
  final Mainscreeniccontroller mainscreeniccontroller;

  @override
  Widget build(BuildContext context) {
    final RxList<Appointment> appointMents = treatmentPatientController
        .appointments
        .where((p0) => p0.treatmentCaseID == dp.id)
        .toList()
        .obs;
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: AppointmentShow(
        childAppointment: ListView.builder(
          itemCount: appointMents.length,
          itemBuilder: (BuildContext context, int i) {
            return AppointmentTile(
              title: DateFormat(
                'yyyy-MM-dd hh : mm a',
              ).format(appointMents[i].timeAppointment),
              appointMents: appointMents,
              index: i,
              colorized: treatmentPatientController.colorized(
                appointMents[i].teethSelected,
              ),

              isButton: false,
            );
          },
        ),
      ),
    );
  }
}
