import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/shared/model/appointment.dart';
import 'package:mysen/features/shared/model/treatment_case.dart';
import 'package:mysen/features/shared/widget/appointment_tile.dart';
import 'package:mysen/features/shared/widget/close.dart';
import 'package:mysen/features/shared/widget/description_flowchartList.dart';

class AppointmentShow extends StatelessWidget {
  const AppointmentShow({
    super.key,
    this.childPhoneAndWhats,
    required this.treatment,
    required this.childAppointment,
    required this.appointments,
    this.phone,
    required this.colorized,
    required this.payPaid,
  });

  final Widget childAppointment;
  final Widget? childPhoneAndWhats;
  final TreatmentCase treatment;
  final RxList<Appointment> appointments;
  final String? phone;
  final int payPaid;
  final List<Map<String, Color>> colorized;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: context.spacing,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: IconButton(
                style: context.iconButtonStyle,
                onPressed: () {
                  Utils.showMyDialog(
                    dismissible: true,
                    widthFactor: .9,
                    heightFactor: .3,
                    colorDialog: context.primarycolor.withAlpha(50),
                    context: context,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.center,
                                "total price".tr,
                                style: context.bodyMeduim,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.center,

                                " ${treatment.totalPrice}",
                                style: context.textAppointment,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.center,
                                "payPaid".tr,
                                style: context.bodyMeduim,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.center,

                                payPaid.toString(),
                                style: context.textAppointment,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.center,
                                "remaining price".tr,
                                style: context.bodyMeduim,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.center,
                                (treatment.totalPrice - payPaid).toString(),
                                style: context.textAppointment,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.book_online),
              ),
            ),
            Text(
              textAlign: TextAlign.center,
              'reserves list'.tr,
              style: context.titleLarge?.copyWith(color: whitecolor),
            ),
            const Closed(),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (BuildContext context, int index) {
              final prevoiusAppointment = appointments.sublist(0, index);
              int prevoiuspaid = 0;
              for (var app in prevoiusAppointment) {
                prevoiuspaid = prevoiuspaid + app.payPrice;
              }
              return AppointmentTile(
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
                              Text('description'.tr, style: context.titleLarge),
                              const Closed(),
                            ],
                          ),
                          DescriptionFlowchartList(
                            isNumber: true,
                            appointMent: appointments[index],
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.description_sharp),
                ),

                title: DateFormat(
                  'yyyy-MM-dd  hh : mm a',
                ).format(appointments[index].timeAppointment),

                index: index,

                colorized: colorized[index],
                isButtonAddTeeth: false,
                totalPrice: treatment.totalPrice,
                prevoiuspaid: prevoiuspaid,
                payPrice: appointments[index].payPrice,
              );
            },
          ),
        ),
        if (childPhoneAndWhats != null) childPhoneAndWhats!,
      ],
    );
  }
}
