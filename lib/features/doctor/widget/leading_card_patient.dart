import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/appointment_controller.dart';
import 'package:mysen/features/doctor/controller/doctorcontroller.dart';
import 'package:mysen/features/doctor/widget/child_phone.dart';
import 'package:mysen/features/shared/model/appointment.dart';
import 'package:mysen/features/shared/model/patientsfordoctor.dart';
import 'package:mysen/features/shared/model/treatment_case.dart';
import 'package:mysen/features/shared/widget/alert.dart';
import 'package:mysen/features/shared/widget/appointment_list.dart';

class LeadingCardPatient extends StatelessWidget {
  const LeadingCardPatient({
    super.key,
    required this.dp,
    required this.doctorcontroller,
    required this.appointmentController,
    required this.treatmentCase,
  });

  final Patientsfordoctor dp;
  final Doctorcontroller doctorcontroller;
  final AppointmentController appointmentController;
  final TreatmentCase treatmentCase;

  @override
  Widget build(BuildContext context) {
    RxList<Appointment> appointMents = <Appointment>[].obs;
    return Row(
      children: [
        IconButton(
          style: context.iconButtonStyle,
          onPressed: () {
            appointMents = appointmentController.appointMents
                .where((p0) => p0.treatmentCaseID == dp.id)
                .toList()
                .obs;

            Utils.showMyDialog(
              color: blackcolor.withAlpha(200),
              context: context,
              child: AppointmentShow(
                childPhoneAndWhats: const ChildPhone(phone: ''),
                childAppointment: Obx(
                  () => ListView.builder(
                    itemCount: appointMents.length,
                    itemBuilder: (BuildContext context, int i) {
                      return AppointmentTile(
                        button: Padding(
                          padding: const EdgeInsetsGeometry.all(10),
                          child: Center(
                            child: Text(
                              textAlign: TextAlign.center,

                              appointMents[i].teethSelected?.first['desc'] ??
                                  '',
                              style: context.bodyMeduim,
                            ),
                          ),
                        ),
                        title: DateFormat(
                          'yyyy-MM-dd  hh : mm a',
                        ).format(appointMents[i].timeAppointment),
                        appointMents: appointMents,
                        index: i,

                        colorized: appointmentController.colorized(
                          appointMents[i].teethSelected,
                        ),
                        deletButton: IconButton(
                          iconSize: context.iconSize,
                          onPressed: () {
                            Utils.showMyDialog(
                              widthFactor: context.mediaSize.width > 600
                                  ? 0.6
                                  : .8,
                              heightFactor: .3,
                              colorDialog: context.colorScheme.error,
                              context: context,
                              child: Alert(
                                isLoading: doctorcontroller.isLoading,
                                confirme: () async {},
                                title: "title delet".tr,
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete),
                        ),
                        isButton: false,
                      );
                    },
                  ),
                ),
              ),
            );
          },
          icon: const Icon(Icons.bookmark_added),
        ),

        const SizedBox.shrink(),
      ],
    );
  }
}
