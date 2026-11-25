import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/appointment_controller.dart';
import 'package:mysen/features/doctor/controller/doctorcontroller.dart';
import 'package:mysen/features/doctor/screen/appointment_dialog.dart';
import 'package:mysen/features/shared/model/patientsfordoctor.dart';
import 'package:mysen/features/shared/model/treatment_case.dart';
import 'package:mysen/features/shared/widget/alert.dart';

class TralingCardPatient extends StatelessWidget {
  const TralingCardPatient({
    super.key,
    required this.doctorcontroller,
    required this.dp,
    required this.appointmentController,
    required this.treatmentCase,
  });

  final Doctorcontroller doctorcontroller;
  final AppointmentController appointmentController;
  final TreatmentCase treatmentCase;
  final Patientsfordoctor dp;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.mediaSize.shortestSide * .2,
      child: Row(
        children: [
          Expanded(
            child: IconButton(
              style: context.iconButtonStyle,
              onPressed: () {
                appointmentController.clearAppointmentController();

                Get.to(
                  () => AppointmetDialog(
                    treatmentCase: treatmentCase,
                    appointmentController: appointmentController,
                  ),
                );
              },

              icon: const Icon(Icons.add),
            ),
          ),
          Expanded(
            child: IconButton(
              style: context.iconButtonStyle,

              onPressed: () {
                Utils.showMyDialog(
                  color: blackcolor.withAlpha(200),
                  heightFactor: .3,
                  widthFactor: context.mediaSize.width > 600 ? 0.6 : .8,

                  colorDialog: context.colorScheme.error,
                  context: context,
                  child: Alert(
                    isLoading: doctorcontroller.isLoading,
                    confirme: () =>
                        doctorcontroller.deletePatintForDoctor(dp.id),

                    title: 'title delet'.tr,
                  ),
                );
              },
              icon: Icon(Icons.delete, color: context.primaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}
