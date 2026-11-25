import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/patients/controller/main_screen_ccontroller.dart';
import 'package:mysen/features/patients/controller/reservation_controller.dart';
import 'package:mysen/features/patients/widget/body_patient.dart';
import 'package:mysen/features/shared/widget/backed.dart';
import 'package:mysen/features/shared/widget/card_drawer.dart';
import 'package:mysen/features/shared/widget/my_drawer.dart';
import 'package:mysen/features/shared/widget/theme_widget.dart';
import 'package:mysen/features/shared/widget/widget_language.dart';

class Reservation extends StatelessWidget {
  Reservation({super.key});
  final Reservationcontroller reservationcontroller = Get.put(
    Reservationcontroller(),
    permanent: true,
  );
  final Mainscreeniccontroller mainscreeniccontroller =
      Get.find<Mainscreeniccontroller>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primarycolor,

      drawer: MyDrawer(
        children: [
          CardDrawer(
            title: 'theme'.tr,
            onTap: () {
              Utils.showMyDialog(
                heightFactor: .5,

                context: context,
                child: ThemeWidget(
                  onPressedCall: (index) =>
                      reservationcontroller.changeTheme(index),
                ),
              );
            },
            iconData: Icons.color_lens,
          ),
          CardDrawer(
            title: 'Language'.tr,
            onTap: () {
              Utils.showMyDialog(
                colorDialog: context.primarycolor,
                widthFactor: .8,
                heightFactor: .3,
                dismissible: true,
                context: context,
                child: WidgetLanguage(
                  onPressedAr: () {
                    reservationcontroller.changelanguage('ar');
                  },
                  onPressedEng: () {
                    reservationcontroller.changelanguage('en');
                  },
                ),
              );
            },
            iconData: Icons.language_outlined,
          ),
        ],
        onPressedSigOut: () {
          reservationcontroller.sigOut();
        },
      ),

      appBar: AppBar(
        iconTheme: IconThemeData(
          color: context.primaryContainer,
          size: context.iconSize,
        ),

        leadingWidth: context.mediaSize.shortestSide * .15,

        toolbarHeight: context.mediaSize.shortestSide * .15,

        backgroundColor: context.primarycolor,

        actions: const [Backed(leftDirction: true)],
        title: FittedBox(
          child: Text(
            '${mainscreeniccontroller.patient?.fullName}',
            style: context.titleLarge,
          ),
        ),
        centerTitle: true,
      ),
      body: BodyPatinet(reservationcontroller: reservationcontroller),
    );
  }
}
