import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/shared/model/doctor.dart';
import 'package:mysen/features/shared/widget/close.dart';

class DoctorEqualityfications extends StatelessWidget {
  const DoctorEqualityfications({
    super.key,
    required this.titileName,
    required this.doctor,
  });

  final Doctor doctor;
  final String titileName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: context.mediaSize.shortestSide * .02,
      children: [
        const Closed(),
        Text(
          titileName,

          style: context.bodyLarge,
        ).animate(delay: const Duration(milliseconds: 500)).fade().moveX(),

        Expanded(
          child: ListView.builder(
            itemCount: doctor.equlatifications?.length ?? 0,
            itemBuilder: (BuildContext context, int i) {
              return ListTile(
                minLeadingWidth: context.mediaSize.shortestSide * .05,
                leading: Icon(
                  size: context.iconSize,
                  Icons.star_rate_rounded,
                  color: context.primaryContainer,
                ),
                title: AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts: [
                    TyperAnimatedText(
                      textStyle: context.bodyMeduim,
                      doctor.equlatifications != null
                          ? doctor.equlatifications![i]
                          : "",
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Spacer(flex: 3),
                    Icon(
                      size: context.iconSize,

                      Icons.phone_android_sharp,
                      color: context.primaryContainer,
                    ),
                    const Spacer(),
                  ],
                ),
              ),

              Expanded(
                child: Text(
                  style: context.number,
                  textAlign: TextAlign.start,

                  doctor.phone['phone'] != null
                      ? doctor.phone['phone'].toString()
                      : "No phone".tr,
                ),
              ),
            ],
          ).animate(delay: const Duration(milliseconds: 500)).fade().moveX(),
        ),
        Directionality(
          textDirection: TextDirection.ltr,

          child:
              Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Spacer(flex: 3),
                            FaIcon(
                              size: context.iconSize,
                              FontAwesomeIcons.whatsapp,
                              color: Colors.green,
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          style: context.number,
                          textAlign: TextAlign.start,

                          doctor.phone['whatsApp'] != null
                              ? doctor.phone['whatsApp'].toString()
                              : "No WhatsApp".tr,
                        ),
                      ),
                    ],
                  )
                  .animate(delay: const Duration(milliseconds: 500))
                  .fade()
                  .moveX(duration: const Duration(seconds: 1)),
        ),
        Icon(
          size: context.iconSize,
          Icons.location_on,
          color: context.colorScheme.error,
        ),
        Text(
          textAlign: TextAlign.center,
          style: context.bodyMeduim?.copyWith(color: context.primaryContainer),
          doctor.location,
        ),
      ],
    ).animate().scale();
  }
}
