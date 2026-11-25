import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysen/core/error.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/doctoreditcontroller.dart';
import 'package:mysen/features/shared/widget/close.dart';
import 'package:mysen/features/shared/widget/my_form_textfiled.dart';

class Editnumbers extends StatelessWidget {
  const Editnumbers({
    super.key,
    required this.title,
    this.onPressed,
    required this.phone,
    required this.doctoreditcontroller,
    required this.lablePhone,
    required this.whats,
    required this.lableWhats,
  });

  final String title;
  final String lablePhone;
  final String lableWhats;
  final void Function()? onPressed;
  final String phone;
  final TextEditingController whats;
  final Doctoreditcontroller doctoreditcontroller;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: context.mediaSize.shortestSide * .05,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: AlignmentGeometry.center,
          children: [
            const Closed(),
            Text(title, style: context.titleLarge),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(phone, style: context.bodyMeduim),
            IconButton(
              style: context.iconButtonStyle,
              onPressed: () {
                MessageHandle.handleMessage(MessageType.phoneDoctorEdit);
              },
              icon: const Icon(Icons.phone_android),
            ),
          ],
        ),

        MytexFormFiled(
          filled: false,
          keyboardType: TextInputType.number,
          controller: whats,
          label: lableWhats,
          validate: Validate.phone,
          prefixText: '966+:',
        ),

        Obx(
          () =>
              OutlinedButton(
                style: context.outlinedButtonStyle,
                onPressed: onPressed,
                child: Text('done'.tr, style: context.bodyMeduim),
              ).loading(
                doctoreditcontroller.isLoading.value,
                context.primaryContainer,
              ),
        ),
      ],
    );
  }
}
