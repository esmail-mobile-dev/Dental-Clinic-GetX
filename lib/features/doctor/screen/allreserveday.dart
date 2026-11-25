import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/appointment_controller.dart';
import 'package:mysen/features/doctor/controller/treatment_controller.dart';
import 'package:mysen/features/doctor/widget/appointment_days.dart';
import 'package:mysen/features/shared/widget/backed.dart';

class Allreserveday extends StatelessWidget {
  Allreserveday({super.key});
  final TreatmentController treatmentController = Get.find();
  final AppointmentController appointmentController = Get.find();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: context.primarycolor,
        appBar: AppBar(
          leading: const Backed(),
          centerTitle: true,
          leadingWidth: context.mediaSize.shortestSide * .15,

          toolbarHeight: context.mediaSize.shortestSide * .15,

          backgroundColor: context.primarycolor,
          title: Text('allReservations'.tr, style: context.titleLarge),
          bottom: TabBar(
            tabs: [
              Tab(child: Text('today'.tr, style: context.bodyMeduim)),
              Tab(child: Text('yesterday'.tr, style: context.bodyMeduim)),
              Tab(child: Text('specificDate'.tr, style: context.bodyMeduim)),
            ],
          ),
        ),
        body: Obx(
          () => TabBarView(
            children: [
              AppointmentDays(
                appointmenstWithPatients: appointmentController.fetchAllReserv(
                  DateTime.now(),
                ),
                appointmentController: appointmentController,
              ),
              AppointmentDays(
                appointmenstWithPatients: appointmentController.fetchAllReserv(
                  DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day - 1,
                  ),
                ),
                appointmentController: appointmentController,
              ),

              Stack(
                alignment: AlignmentGeometry.topRight,
                children: [
                  AppointmentDays(
                    appointmenstWithPatients: appointmentController
                        .fetchAllReserv(
                          appointmentController.dateTimeAppointemntDays.value,
                        ),
                    appointmentController: appointmentController,
                  ),

                  Card(
                    color: context.primarycolor,
                    shadowColor: blackcolor,
                    elevation: elevation,
                    child: IconButton(
                      style: context.iconButtonStyle,
                      onPressed: () async {
                        final dateappintemt = await showDatePicker(
                          builder: (context, child) =>
                              FractionallySizedBox(child: child),
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(3000),
                        );

                        if (dateappintemt != null) {
                          appointmentController.setDateDays(dateappintemt);
                        }
                      },
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
