import 'package:flutter/material.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/appointment_controller.dart';
import 'package:mysen/features/doctor/controller/treatment_controller.dart';
import 'package:mysen/features/doctor/widget/form_treatment.dart';
import 'package:mysen/features/doctor/widget/listDelete_treatment.dart';
import 'package:mysen/features/shared/model/patientsfordoctor.dart';

class BottomNavigationBarTreatment extends StatelessWidget {
  const BottomNavigationBarTreatment({
    super.key,
    required this.treatmentController,
    required this.dp,
    required this.appointmentController,
  });

  final TreatmentController treatmentController;
  final Patientsfordoctor dp;
  final AppointmentController appointmentController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(bottom: context.mediaSize.shortestSide * .05),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Card(
            elevation: 2,
            color: context.primaryContainer,
            child: IconButton(
              style: context.iconButtonStyle,
              onPressed: () {
                Utils.showMyDialog(
                  widthFactor: .8,
                  heightFactor: .4,
                  context: context,
                  child: FormTreatment(
                    treatmentController: treatmentController,
                    dp: dp,
                  ),
                );
              },
              icon: Icon(Icons.add, color: context.primarycolor),
            ),
          ),
          Card(
            elevation: 2,
            color: context.primaryContainer,
            child: IconButton(
              style: context.iconButtonStyle,
              onPressed: () {
                Utils.showMyDialog(
                  context: context,
                  child: ListDeleteTreatment(
                    treatmentController: treatmentController,
                    dp: dp,
                    appointmentController: appointmentController,
                  ),
                );
              },
              icon: Icon(
                Icons.delete_forever_rounded,
                color: context.primarycolor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
