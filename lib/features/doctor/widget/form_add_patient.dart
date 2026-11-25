import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/doctorcontroller.dart';
import 'package:mysen/features/shared/widget/close.dart';
import 'package:mysen/features/shared/widget/my_form_textfiled.dart';

class FormAddpatient extends StatelessWidget {
  const FormAddpatient({
    super.key,
    required this.title,
    required this.controllerName,
    required this.controllerPhone,
    this.onPressed,
    this.color,
    required this.doctorcontroller,
    required this.controllerNickName,
  });

  final String title;
  final TextEditingController controllerName;
  final TextEditingController controllerNickName;
  final TextEditingController controllerPhone;
  final Doctorcontroller doctorcontroller;
  final Color? color;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: doctorcontroller.formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: context.spacing,
          children: [
            Stack(
              alignment: AlignmentGeometry.center,
              children: [
                const Closed(),
                Text(
                  title,
                  style: context.titleLarge?.copyWith(
                    color: context.primaryContainer,
                  ),
                ),
              ],
            ),
            MytexFormFiled(
              filled: false,

              controller: controllerName,
              label: "name".tr,
              validate: Validate.name,
            ),
            MytexFormFiled(
              filled: false,

              controller: controllerNickName,
              label: "nickName".tr,
              validate: Validate.nickName,
            ),

            MytexFormFiled(
              filled: false,
              validate: Validate.phone,
              keyboardType: TextInputType.number,
              controller: controllerPhone,
              label: "phone".tr,
              prefixText: '966+:',
            ),

            Obx(
              () => FractionallySizedBox(
                widthFactor: .8,
                child:
                    OutlinedButton(
                      style: context.outlinedButtonStyle,
                      onPressed: onPressed,
                      child: Text("Add".tr, style: context.bodyMeduim),
                    ).loading(
                      doctorcontroller.isLoading.value,
                      color ?? whitecolor,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
