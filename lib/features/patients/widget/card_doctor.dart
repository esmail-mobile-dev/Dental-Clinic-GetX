import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/patients/controller/main_screen_ccontroller.dart';
import 'package:mysen/features/patients/widget/doctor_eqalitification.dart';
import 'package:mysen/features/shared/widget/alert.dart';

class CardDoctor extends StatelessWidget {
  const CardDoctor({
    super.key,
    required this.urlimage,
    required this.index,
    required this.mainscreeniccontroller,
  });

  final String? urlimage;
  final int index;
  final Mainscreeniccontroller mainscreeniccontroller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Mainscreeniccontroller>(
      builder: (controller) {
        final doctor = mainscreeniccontroller.doctors[index];
        final request = mainscreeniccontroller.requests
            .where((r) => r.doctorID == doctor.id)
            .firstOrNull;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          mainscreeniccontroller.handleRequestState(
            request?.stateRequest ?? StateRequest.none,
          );
        });
        return AnimatedBuilder(
          animation: mainscreeniccontroller.animationController,
          builder: (context, child) => FractionallySizedBox(
            widthFactor: .8,
            heightFactor: .5,
            child: Container(
              padding: EdgeInsets.only(bottom: context.padding),
              clipBehavior: Clip.none,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.raduis),
                border: Border.all(
                  color: mainscreeniccontroller.getColor(
                    request?.stateRequest ?? StateRequest.none,
                    context,
                  ),

                  width: mainscreeniccontroller.getWidthBorder(
                    request?.stateRequest ?? StateRequest.none,
                  ),
                ),
                color: context.primarycolor,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) => Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -constraints.maxHeight * .2,
                      height: constraints.maxHeight * .8,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: urlimage == null || urlimage == ''
                            ? FittedBox(
                                child: Icon(
                                  Icons.person,
                                  color: context.primaryContainer,
                                ),
                              )
                            : CachedNetworkImage(
                                    imageUrl: urlimage ?? '',

                                    progressIndicatorBuilder:
                                        (context, url, progress) => Center(
                                          child: CircularProgressIndicator(
                                            value: progress.progress,
                                          ),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        FittedBox(
                                          child: Icon(
                                            Icons.person,
                                            color: context.primaryContainer,
                                          ),
                                        ),
                                  )
                                  .animate()
                                  .scale(
                                    duration: const Duration(milliseconds: 800),
                                  )
                                  .fade(
                                    duration: const Duration(milliseconds: 800),
                                  ),
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      height: constraints.maxHeight * .4,
                      width: constraints.maxWidth,

                      child: Obx(
                        () => Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              mainscreeniccontroller.doctors[index].gender ==
                                      Gender.male
                                  ? 'doctor_male'.tr
                                  : 'doctor_female'.tr,
                              style: context.bodyLarge?.copyWith(
                                color: context.primaryContainer,
                              ),
                            ),
                            Text(
                              "${mainscreeniccontroller.doctors[index].fullName.split(' ').sublist(0, 2).join(' ')} ${mainscreeniccontroller.doctors[index].fullName.split(' ').last} ",

                              style: context.bodyLarge,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: context.spacing,
                              children: [
                                ExpandIcon(
                                  size: context.iconSize,
                                  color: context.primaryContainer,
                                  onPressed: (value) {
                                    Utils.showMyDialog(
                                      widthFactor: 1,
                                      heightFactor: 1,

                                      context: context,
                                      child: DoctorEqualityfications(
                                        titileName:
                                            "${'D'.tr}/ ${mainscreeniccontroller.doctors[index].fullName.split(" ").sublist(0, 2).join(' ')}  ${mainscreeniccontroller.doctors[index].fullName.split(' ').last}",
                                        doctor: mainscreeniccontroller
                                            .doctors[index],
                                      ),
                                    );
                                  },
                                ),
                                !doctor.isWorking
                                    ? Text(
                                        'holiday'.tr,
                                        style: context.bodyLarge,
                                      )
                                    : OutlinedButton(
                                        style: context.outlinedButtonStyle
                                            ?.copyWith(
                                              minimumSize:
                                                  WidgetStatePropertyAll(
                                                    Size(
                                                      constraints.maxWidth * .4,
                                                      constraints.maxWidth *
                                                          .11,
                                                    ),
                                                  ),
                                            ),

                                        onPressed: () {
                                          Utils.showMyDialog(
                                            dismissible: true,

                                            heightFactor: .3,
                                            widthFactor: .8,

                                            colorDialog: context.primarycolor,
                                            context: context,
                                            child: Alert(
                                              title:
                                                  request?.stateRequest ==
                                                      StateRequest.waiting
                                                  ? 'title requestcancel'.tr
                                                  : 'title request'.tr,
                                              confirme: () {
                                                request?.stateRequest ==
                                                        StateRequest.waiting
                                                    ? mainscreeniccontroller
                                                          .updateRequestToNon(
                                                            request,
                                                          )
                                                    : mainscreeniccontroller
                                                          .addResqustReserv(
                                                            doctor.id,
                                                          );
                                              },
                                              isLoading: false.obs,
                                            ),
                                          );
                                        },

                                        child: Text(
                                          request?.stateRequest ==
                                                  StateRequest.waiting
                                              ? 'cancelRequest'.tr
                                              : 'requestTitle'.tr,
                                          style: context.bodyMeduim,
                                        ),
                                      ).loading(
                                        mainscreeniccontroller.isLoading.value,
                                        context.primaryContainer,
                                      ),
                              ],
                            ),

                            Row(
                              children: [
                                const Spacer(),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    'time Appointment'.tr,
                                    style: context.bodyMeduim,
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    textAlign: TextAlign.center,

                                    request?.reciveTime == null
                                        ? 'noAppointment'.tr
                                        : DateFormat(
                                            'yyyy-MM-dd HH:mm a',
                                          ).format(request!.reciveTime!),
                                    textDirection: ui.TextDirection.ltr,
                                    style: context.textAppointment,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
