import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/appointment_controller.dart';
import 'package:mysen/features/shared/model/appointmentWithPatient.dart';
import 'package:mysen/features/shared/widget/close.dart';
import 'package:mysen/features/shared/widget/description_flowchartList.dart';
import 'package:mysen/features/shared/widget/teeth_floawchart_button.dart';

class AppointmentDays extends StatelessWidget {
  const AppointmentDays({
    super.key,
    required this.appointmenstWithPatients,
    required this.appointmentController,
  });

  final List<Appointmentwithpatient> appointmenstWithPatients;
  final AppointmentController appointmentController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(context.padding),
      itemCount: appointmenstWithPatients.length,
      itemBuilder: (BuildContext context, int index) {
        final appointmentWithPatient = appointmenstWithPatients[index];
        return Card(
          margin: EdgeInsets.all(context.margin),
          color: context.primarycolor,
          shadowColor: blackcolor,
          elevation: 2,
          child: ListTile(
            title: Text(
              textAlign: TextAlign.center,
              appointmentWithPatient.patientName,
              style: context.bodyMeduim,
            ),
            subtitle: Text(
              textDirection: ui.TextDirection.ltr,
              textAlign: TextAlign.center,
              DateFormat(
                'yyyy-MM-dd hh:mm a',
              ).format(appointmentWithPatient.appointment.timeAppointment),
              style: context.bodyMeduim,
            ),
            leading: appointmentWithPatient.appointment.teethSelected == null
                ? const SizedBox.shrink()
                : IconButton(
                    iconSize: context.iconSize,
                    onPressed: () {
                      Utils.showMyDialog(
                        context: context,
                        child: TeethFlowchart(
                          widgetDescription: IconButton(
                            style: context.iconButtonStyle,
                            onPressed: () {
                              Utils.showMyDialog(
                                context: context,
                                child: Column(
                                  spacing: context.mediaSize.shortestSide * .02,
                                  children: [
                                    Stack(
                                      alignment: AlignmentGeometry.center,
                                      children: [
                                        Text(
                                          'description'.tr,
                                          style: context.titleLarge,
                                        ),
                                        const Closed(),
                                      ],
                                    ),
                                    DescriptionFlowchartList(
                                      isNumber: true,
                                      appointMent:
                                          appointmentWithPatient.appointment,
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.description_sharp),
                          ),
                          isButtonAddTeeth: false,
                          onChangeSelectTeeth: (p0) {},
                          colorized: appointmentController.colorized(
                            appointmentWithPatient.appointment.teethSelected,
                          ),

                          widgetTeethButton: null,
                          initiallySelected: const [],
                        ),
                      );
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.tooth,
                      color: context.primaryContainer,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
