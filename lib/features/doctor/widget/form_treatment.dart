import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/treatment_controller.dart';
import 'package:mysen/features/shared/model/patientsfordoctor.dart';
import 'package:mysen/features/shared/widget/close.dart';
import 'package:mysen/features/shared/widget/my_form_textfiled.dart';

class FormTreatment extends StatelessWidget {
  const FormTreatment({
    super.key,
    required this.treatmentController,
    required this.dp,
  });

  final TreatmentController treatmentController;
  final Patientsfordoctor dp;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: treatmentController.formKeyTreatment,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Stack(
            alignment: AlignmentGeometry.center,
            children: [
              const Closed(),
              Text('AddTreatmentPlan'.tr, style: context.titleLarge),
            ],
          ),

          MytexFormFiled(
            filled: false,
            controller: treatmentController.totalPrice,
            keyboardType: TextInputType.number,
            label: 'total price'.tr,
            validate: Validate.price,
          ),

          Obx(
            () =>
                OutlinedButton(
                  style: context.outlinedButtonStyle,
                  onPressed: () {
                    treatmentController.addTreatmentCase(dp.id);
                  },
                  child: Text('done'.tr, style: context.bodyMeduim),
                ).loading(
                  treatmentController.isLoading.value,
                  context.primaryContainer,
                ),
          ),
        ],
      ),
    );
  }
}
