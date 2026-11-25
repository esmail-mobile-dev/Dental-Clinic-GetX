import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/notficationcontroller.dart';
import 'package:mysen/features/shared/widget/close.dart';

class Accept extends StatelessWidget {
  const Accept({
    super.key,
    required this.notficationcontroller,
    this.onPressed,
  });

  final Notficationcontroller notficationcontroller;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: context.spacing,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            const Closed(),
            Text('time Appointment'.tr, style: context.titleLarge),
          ],
        ),

        Row(
          children: [
            IconButton(
              style: context.iconButtonStyle,
              onPressed: () async {
                final timeappintemt = await showTimePicker(
                  builder: (context, child) =>
                      FractionallySizedBox(child: child),
                  context: context,
                  initialTime: TimeOfDay(
                    hour: DateTime.now().hour,
                    minute: DateTime.now().minute,
                  ),
                );
                if (timeappintemt != null) {
                  notficationcontroller.setTime(timeappintemt);
                }
              },
              icon: const Icon(Icons.alarm_outlined),
            ),
            IconButton(
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
                  notficationcontroller.setDate(dateappintemt);
                }
              },
              icon: const Icon(Icons.calendar_month),
            ),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: context.mediaSize.shortestSide * .02,

                children: [
                  Text("${'date'.tr} : ", style: context.textAppointment),
                  Obx(
                    () => Text(
                      textDirection: ui.TextDirection.ltr,

                      DateFormat(
                        'yyyy-MM-dd hh:mm a',
                      ).format(notficationcontroller.dateTimeAppointemnt.value),
                      style: context.textAppointment,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        Obx(
          () =>
              OutlinedButton(
                style: context.outlinedButtonStyle,
                onPressed: onPressed,
                child: Text('done'.tr),
              ).loading(
                notficationcontroller.isLoading.value,
                context.primaryContainer,
              ),
        ),
      ],
    );
  }
}
