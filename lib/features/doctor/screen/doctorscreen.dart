import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/doctorcontroller.dart';
import 'package:mysen/features/doctor/widget/Bottomnavgiationbar_doctor.dart';
import 'package:mysen/features/doctor/widget/body_doctor.dart';
import 'package:mysen/features/doctor/widget/drawer_doctor.dart';

class Doctorscreen extends StatelessWidget {
  Doctorscreen({super.key});
  final Doctorcontroller doctorcontroller = Get.put(Doctorcontroller());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: context.primarycolor,
        bottomNavigationBar: BottomNavgiationBarDoctor(
          doctorcontroller: doctorcontroller,
        ),

        drawer: DrawerDoctor(controller: doctorcontroller),

        appBar: AppBar(
          iconTheme: IconThemeData(
            color: context.primaryContainer,
            size: context.iconSize,
          ),
          leadingWidth: context.mediaSize.shortestSide * .15,

          toolbarHeight: context.mediaSize.shortestSide * .15,
          centerTitle: true,

          backgroundColor: context.primarycolor,

          title: FittedBox(
            child: Obx(
              () => Text(
                textAlign: TextAlign.center,
                '${doctorcontroller.doctorfullName}',
                style: context.titleLarge,
              ),
            ),
          ),
        ),

        body: BodyDoctor(doctorcontroller: doctorcontroller),
      ),
    );
  }
}
