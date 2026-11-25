import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/appointment_controller.dart';
import 'package:mysen/features/doctor/controller/treatment_controller.dart';
import 'package:mysen/features/doctor/widget/body_treatment.dart';
import 'package:mysen/features/doctor/widget/bottomnavigationbar_treatment.dart';
import 'package:mysen/features/shared/widget/backed.dart';
import 'package:mysen/features/shared/model/patientsfordoctor.dart';

class TreatmentCaseScreenDoctor extends StatelessWidget {
  TreatmentCaseScreenDoctor({super.key, required this.dp});
  final TreatmentController treatmentController = Get.find();
  final AppointmentController appointmentController = Get.find();

  final Patientsfordoctor dp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primarycolor,
      bottomNavigationBar: BottomNavigationBarTreatment(
        treatmentController: treatmentController,
        dp: dp,
        appointmentController: appointmentController,
      ),
      appBar: AppBar(
        toolbarHeight: context.mediaSize.shortestSide * .15,
        leadingWidth: context.mediaSize.shortestSide * .15,

        leading: const Backed(),
        automaticallyImplyLeading: false,
        title: Text(dp.fullName, style: context.titleLarge),
        centerTitle: true,

        backgroundColor: context.primarycolor,
      ),
      body: BodyTreatment(
        treatmentController: treatmentController,
        dp: dp,
        appointmentController: appointmentController,
      ),
    );
  }
}
