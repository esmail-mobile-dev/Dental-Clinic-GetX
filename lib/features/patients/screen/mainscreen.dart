import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mysen/core/approut.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/patients/controller/main_screen_ccontroller.dart';
import 'package:mysen/features/patients/widget/card_doctor.dart';

class Mainscreen extends StatelessWidget {
  Mainscreen({super.key});

  final Mainscreeniccontroller mainscreeniccontroller =
      Get.put<Mainscreeniccontroller>(Mainscreeniccontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primarycolor,
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Obx(
          () => Stack(
            children: [
              Positioned.fill(
                child: PageView.builder(
                  itemCount: mainscreeniccontroller.doctors.length,
                  controller: mainscreeniccontroller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    String? imgurl =
                        mainscreeniccontroller.doctors[index].imgUrl;

                    return FittedBox(
                      fit: BoxFit.cover,
                      child: imgurl == null || imgurl == ''
                          ? const SizedBox.shrink()
                          : CachedNetworkImage(
                              imageUrl: imgurl,

                              errorWidget: (context, url, error) =>
                                  const SizedBox.shrink(),
                            ),
                    );
                  },
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: blackcolor.withAlpha(100)),
              ),
              Positioned.fill(
                child: PageView(
                  onPageChanged: (value) {
                    final doctor = mainscreeniccontroller.doctors[value];
                    final request = mainscreeniccontroller.requests
                        .where((r) => r.doctorID == doctor.id)
                        .firstOrNull;

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      mainscreeniccontroller.handleRequestState(
                        request?.stateRequest ?? StateRequest.none,
                      );
                    });
                  },
                  controller: mainscreeniccontroller.pageControllerCard,
                  children: [
                    ...List.generate(
                      mainscreeniccontroller.doctors.length,
                      (index) =>
                          CardDoctor(
                            urlimage:
                                mainscreeniccontroller.doctors[index].imgUrl,
                            index: index,
                            mainscreeniccontroller: mainscreeniccontroller,
                          ).animate().shimmer(
                            size: 2,
                            color: context.primaryContainer.withAlpha(50),

                            duration: const Duration(milliseconds: 500),
                          ),
                    ),
                  ],
                ),
              ),

              SafeArea(
                minimum: EdgeInsets.all(context.padding),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton.outlined(
                    style: context.iconButtonStyle,

                    onPressed: () {
                      mainscreeniccontroller.rout(Approut.reservation);
                    },
                    icon: Icon(Icons.person, color: context.primaryContainer),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
