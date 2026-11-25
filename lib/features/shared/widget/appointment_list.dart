import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/shared/model/appointment.dart';
import 'package:mysen/features/shared/widget/teeth_floawchart_button.dart';

class AppointmentShow extends StatelessWidget {
  const AppointmentShow({
    super.key,
    required this.childAppointment,
    this.childPhoneAndWhats,
  });

  final Widget childAppointment;
  final Widget? childPhoneAndWhats;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: MediaQuery.of(context).size.shortestSide * .04,
      children: [
        Row(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    'reserves list'.tr,
                    style: context.titleLarge?.copyWith(color: whitecolor),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      style: context.iconButtonStyle,
                      onPressed: () {
                        if (Get.isOverlaysOpen ||
                            Get.key.currentState?.canPop() == true) {
                          Get.back();
                        }
                      },
                      icon: Icon(Icons.clear, color: context.primaryContainer),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Expanded(child: childAppointment),
        if (childPhoneAndWhats != null) childPhoneAndWhats!,
      ],
    );
  }
}

class AppointmentTile extends StatelessWidget {
  const AppointmentTile({
    super.key,
    required this.title,
    required this.appointMents,
    required this.index,
    required this.colorized,
    this.deletButton,
    required this.isButton,
    this.button,
  });

  final String title;
  final RxList<Appointment> appointMents;
  final int index;
  final Map<String, Color> colorized;
  final Widget? deletButton;
  final bool isButton;
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.shortestSide * .05,
          right: MediaQuery.of(context).size.shortestSide * .01,
          left: MediaQuery.of(context).size.shortestSide * .01,
        ),
        child: ExpansionTile(
          trailing: Icon(Icons.expand_more, size: context.iconSize),

          iconColor: whitecolor,
          minTileHeight: MediaQuery.of(context).size.shortestSide * .13,
          collapsedIconColor: context.primarycolor,
          leading: SizedBox(
            width: MediaQuery.of(context).size.shortestSide * .23,
            child: Row(
              children: [
                Expanded(
                  child: IconButton(
                    iconSize: context.mediaSize.shortestSide * .05,
                    onPressed: () {
                      Utils.showMyDialog(
                        color: blackcolor.withAlpha(150),
                        sigmaX: 5,
                        sigmaY: 5,

                        context: context,
                        child: TeethFlowchart(
                          onChangeSelectTeeth: (p0) {},
                          colorized: colorized,

                          isButtonAddTeeth: false,
                          widgetTeethButton: null,
                          initiallySelected: [],
                        ),
                      );
                    },
                    icon: const FaIcon(FontAwesomeIcons.tooth),
                  ),
                ),
                if (deletButton != null)
                  Expanded(child: deletButton ?? const SizedBox.shrink()),
                const SizedBox(width: 10),
              ],
            ),
          ),

          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.shortestSide * .02,
            ),
          ),
          collapsedBackgroundColor: context.primaryContainer.withAlpha(200),
          backgroundColor: blackcolor.withAlpha(150),

          title: Column(
            children: [
              Text('time Appointment'.tr, style: context.bodyMeduim),
              Text(
                title,
                style: context.bodyMeduim,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3.5,
              width: MediaQuery.of(context).size.width,
              child: Directionality(
                textDirection: Get.locale == const Locale('ar')
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AppointmentTable(
                      title: 'total price'.tr,
                      traling: appointMents[index].payPrice.toString(),
                    ),
                    AppointmentTable(
                      title: 'pay price'.tr,
                      traling: appointMents[index].payPrice.toString(),
                    ),
                    AppointmentTable(
                      title: 'remaining price'.tr,
                      traling: appointMents[index].payPrice.toString(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentTable extends StatelessWidget {
  const AppointmentTable({
    super.key,
    required this.title,
    required this.traling,
  });

  final String title;
  final String traling;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AnimatedTextKit(
            repeatForever: false,
            totalRepeatCount: 1,

            animatedTexts: [
              TyperAnimatedText(
                textAlign: TextAlign.justify,
                textStyle: context.bodyMeduim,
                title,
                speed: const Duration(milliseconds: 50),
              ),
            ],
          ),
          AnimatedTextKit(
            repeatForever: false,
            totalRepeatCount: 1,
            animatedTexts: [
              TyperAnimatedText(
                textAlign: TextAlign.center,
                textStyle: context.number,

                traling,
                speed: const Duration(milliseconds: 150),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
