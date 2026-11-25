import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:mysen/core/approut.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/doctorcontroller.dart';
import 'package:mysen/features/shared/widget/card_drawer.dart';
import 'package:mysen/features/shared/widget/my_drawer.dart';
import 'package:mysen/features/shared/widget/theme_widget.dart';
import 'package:mysen/features/shared/widget/widget_language.dart';

class DrawerDoctor extends StatelessWidget {
  const DrawerDoctor({super.key, required this.controller});

  final Doctorcontroller controller;

  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      children: [
        CardDrawer(
          title: "doctor profile".tr,
          iconData: Icons.person,
          onTap: () {
            controller.rout(Approut.doctorEditing);
          },
        ),

        CardDrawer(
          title: "theme".tr,
          iconData: Icons.color_lens,
          onTap: () {
            Utils.showMyDialog(
              heightFactor: .5,
              context: context,
              child: ThemeWidget(
                onPressedCall: (index) => controller.changeTheme(index),
              ),
            );
          },
        ),
        CardDrawer(
          title: 'Language'.tr,
          iconData: Icons.language_outlined,
          onTap: () {
            Utils.showMyDialog(
              colorDialog: context.primarycolor,
              widthFactor: .8,
              heightFactor: .3,
              dismissible: true,
              context: context,
              child: WidgetLanguage(
                onPressedAr: () {
                  controller.changelanguage('ar');
                },
                onPressedEng: () {
                  controller.changelanguage('en');
                },
              ),
            );
          },
        ),
      ],
      onPressedSigOut: () => controller.sigOut(),
    );
  }
}
