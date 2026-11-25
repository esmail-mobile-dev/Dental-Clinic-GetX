import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/doctoreditcontroller.dart';
import 'package:mysen/features/shared/widget/close.dart';
import 'package:mysen/features/shared/widget/my_form_textfiled.dart';

class LocationDoctorEdit extends StatelessWidget {
  const LocationDoctorEdit({super.key, required this.doctoreditcontroller});

  final Doctoreditcontroller doctoreditcontroller;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: context.mediaSize.shortestSide * .05,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: AlignmentGeometry.center,
          children: [
            const Closed(),
            Row(
              spacing: context.mediaSize.shortestSide * .02,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  size: context.iconSize,
                  Icons.location_on,
                  color: context.colorScheme.error,
                ),
                Text('Add location'.tr, style: context.titleLarge),
              ],
            ),
          ],
        ),
        Form(
          key: doctoreditcontroller.formKeyLocation,

          child: MytexFormFiled(
            filled: false,
            controller: doctoreditcontroller.locationcontroller,
            label: 'location'.tr,
            validate: Validate.location,
          ),
        ),

        FractionallySizedBox(
          widthFactor: 1,
          child: Text(
            doctoreditcontroller.doctor?.location ?? '',

            style: context.bodyMeduim,
          ),
        ),

        Obx(
          () => FractionallySizedBox(
            widthFactor: 1,
            child:
                OutlinedButton(
                  style: context.outlinedButtonStyle,
                  onPressed: () {
                    doctoreditcontroller.updateDoctor(
                      doctoreditcontroller.doctor?.copyWith(
                        location: doctoreditcontroller.locationcontroller.text,
                      ),
                      Validate.location,
                    );
                  },
                  child: Text('done'.tr, style: context.bodyMeduim),
                ).loading(
                  doctoreditcontroller.isLoading.value,
                  context.primaryContainer,
                ),
          ),
        ),
      ],
    );
  }
}
