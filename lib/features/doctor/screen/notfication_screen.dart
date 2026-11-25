import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/utiles.dart';
import 'dart:ui' as ui;

import 'package:mysen/features/doctor/controller/doctorcontroller.dart';
import 'package:mysen/features/doctor/controller/notficationcontroller.dart';
import 'package:mysen/features/doctor/widget/accept.dart';
import 'package:mysen/features/shared/model/request_reservation.dart';
import 'package:mysen/features/shared/widget/alert.dart';
import 'package:mysen/features/shared/widget/backed.dart';

class Notfictionscreen extends StatelessWidget {
  Notfictionscreen({super.key});

  final Notficationcontroller notficationcontroller = Get.put(
    Notficationcontroller(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    Doctorcontroller doctorcontroller = notficationcontroller.doctorcontroller;

    return Scaffold(
      backgroundColor: context.primarycolor,

      appBar: AppBar(
        toolbarHeight: context.mediaSize.shortestSide * .15,
        leadingWidth: context.mediaSize.shortestSide * .15,

        backgroundColor: context.primarycolor,

        leading: const Backed(),
        automaticallyImplyLeading: false,
        title: Text("notfication reservation".tr, style: context.titleLarge),
        centerTitle: true,
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () async {
            if (notficationcontroller.isfetch) {
              notficationcontroller.fetchRequest();
            }
          },
          child: ListView.builder(
            itemCount: doctorcontroller.requestRservationForNotfication.length,
            itemBuilder: (BuildContext context, int index) {
              final Requestreservation request =
                  doctorcontroller.requestRservationForNotfication[index];
              final isExist = doctorcontroller.patientsfordoctor.any(
                (element) => element.patientID == request.patientID,
              );

              return Card(
                elevation: elevation,
                color: blackcolor.withAlpha(100),
                margin: EdgeInsets.all(context.margin),
                child: Padding(
                  padding: EdgeInsetsGeometry.all(context.padding),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Utils.showMyDialog(
                            widthFactor: .9,

                            context: context,
                            child: Accept(
                              notficationcontroller: notficationcontroller,
                              onPressed: () {
                                notficationcontroller.accept(request);
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Accept".tr,
                          style: context.textAppointment,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isExist)
                              Text('New'.tr, style: context.textAppointment),
                            Text(
                              request.patientName,
                              style: context.bodyMeduim,
                            ),
                            Text(
                              textDirection: ui.TextDirection.ltr,
                              DateFormat(
                                'yyyy -MM-dd hh mm a',
                              ).format(request.sendTime ?? DateTime.now()),
                              style: context.bodyMeduim,
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Utils.showMyDialog(
                            heightFactor: .3,
                            widthFactor: .8,
                            colorDialog: context.colorScheme.error,
                            context: context,
                            child: Alert(
                              confirme: () async {
                                notficationcontroller.reject(request);
                              },

                              title: "title reject".tr,
                              isLoading: doctorcontroller.isLoading,
                            ),
                          );
                        },
                        child: Text(
                          "reject".tr,
                          style: context.bodySmallNotfication?.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
