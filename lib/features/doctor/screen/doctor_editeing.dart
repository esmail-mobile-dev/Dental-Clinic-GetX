import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/doctoreditcontroller.dart';
import 'package:mysen/features/doctor/widget/doctor_edit_details.dart';
import 'package:mysen/features/shared/widget/backed.dart';

class DoctorEditing extends StatelessWidget {
  DoctorEditing({super.key});
  final Doctoreditcontroller doctoreditcontroller = Get.put(
    permanent: true,
    Doctoreditcontroller(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primarycolor,
      resizeToAvoidBottomInset: false,
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: GetBuilder<Doctoreditcontroller>(
          builder: (controller) {
            final imgurl = controller.doctor?.imgUrl;

            return controller.doctor == null
                ? const SizedBox.shrink()
                : ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      controller.doctor?.isWorking ?? true
                          ? Colors.transparent
                          : context.primaryContainer,
                      BlendMode.color,
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: imgurl == null
                              ? const FittedBox(child: Icon(Icons.person))
                              : CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: imgurl,

                                  placeholderFadeInDuration: const Duration(
                                    seconds: 1,
                                  ),
                                  progressIndicatorBuilder:
                                      (context, url, progress) => Center(
                                        child: CircularProgressIndicator(
                                          value: progress.progress,
                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      const FittedBox(
                                        child: Icon(Icons.person),
                                      ),
                                ),
                        ),
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(color: blackcolor.withAlpha(100)),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(
                              bottom: context.mediaQuerySize.shortestSide * .02,
                            ),
                            decoration: BoxDecoration(
                              color: context.primarycolor,

                              borderRadius: BorderRadius.circular(
                                context.raduis,
                              ),
                            ),
                            child: FractionallySizedBox(
                              widthFactor: .8,
                              heightFactor: .5,
                              child: LayoutBuilder(
                                builder: (context, constraints) => Stack(
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      height: constraints.maxHeight * .35,
                                      width: constraints.maxWidth * .8,
                                      bottom: 0,
                                      child: DoctorEditDetails(
                                        doctoreditcontroller:
                                            doctoreditcontroller,
                                      ),
                                    ),
                                    Positioned(
                                      height: constraints.maxHeight * .8,
                                      top: -constraints.maxHeight * .2,

                                      child: imgurl == null
                                          ? FittedBox(
                                              child: Icon(
                                                Icons.person,
                                                color: context.primaryContainer,
                                              ),
                                            )
                                          : CachedNetworkImage(
                                                  imageUrl: doctoreditcontroller
                                                      .doctor!
                                                      .imgUrl!,

                                                  placeholderFadeInDuration:
                                                      const Duration(
                                                        seconds: 1,
                                                      ),
                                                  progressIndicatorBuilder:
                                                      (
                                                        context,
                                                        url,
                                                        progress,
                                                      ) => Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                              value: progress
                                                                  .progress,
                                                            ),
                                                      ),
                                                  errorWidget:
                                                      (
                                                        context,
                                                        url,
                                                        error,
                                                      ) => FittedBox(
                                                        child: Icon(
                                                          Icons.person,
                                                          color: context
                                                              .primaryContainer,
                                                        ),
                                                      ),
                                                )
                                                .animate()
                                                .scale(
                                                  duration: const Duration(
                                                    milliseconds: 500,
                                                  ),
                                                )
                                                .fade(
                                                  duration: const Duration(
                                                    milliseconds: 800,
                                                  ),
                                                ),
                                    ),
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Backed(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SafeArea(
                          child: Align(
                            alignment: const FractionalOffset(1, 0),
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(
                                context.mediaSize.shortestSide * .05,
                              ),
                              child: Obx(
                                () => Transform.scale(
                                  scale: context.mediaSize.shortestSide * .002,
                                  child: !doctoreditcontroller.isworkState.value
                                      ? Text(
                                          style: context.bodyMeduim,
                                          '${doctoreditcontroller.remainingSeconds.value ~/ 60}:'
                                          '${(doctoreditcontroller.remainingSeconds.value % 60).toString().padLeft(2, '0')}',
                                        )
                                      : Switch(
                                          value:
                                              controller.doctor?.isWorking ??
                                              true,
                                          onChanged: (value) {
                                            controller.updateDoctorWorking(
                                              value,
                                            );
                                          },
                                          inactiveThumbColor: blackcolor,

                                          trackColor: WidgetStatePropertyAll(
                                            context.primaryContainer,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
