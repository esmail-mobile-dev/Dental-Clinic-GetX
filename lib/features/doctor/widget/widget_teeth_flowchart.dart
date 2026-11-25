import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/appointment_controller.dart';
import 'package:mysen/features/shared/widget/close.dart';
import 'package:mysen/features/shared/widget/my_form_textfiled.dart';

class WidgetTeethFlowChart extends StatelessWidget {
  final AppointmentController appointmentController;
  const WidgetTeethFlowChart({super.key, required this.appointmentController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: appointmentController.teethAdd.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Utils.showMyDialog(
                  widthFactor: .9,
                  heightFactor: .9,
                  context: context,
                  child: Column(
                    spacing: context.spacing,

                    children: [
                      Row(
                        children: [
                          const Closed(),
                          Expanded(
                            child: Center(
                              child: Text(
                                'AddDescription'.tr,
                                style: context.titleLarge,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            spacing: context.mediaSize.shortestSide * .05,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MytexFormFiled(
                                filled: false,
                                controller:
                                    appointmentController.descruptionController,
                                label:
                                    "🦷${appointmentController.teethAdd[index]['number']}",
                                validate: Validate.none,
                              ),

                              Text(
                                style: context.bodyMeduim,
                                appointmentController
                                    .teethAdd[index]['description'],
                              ),

                              Center(
                                child: FractionallySizedBox(
                                  widthFactor: .8,
                                  child: OutlinedButton(
                                    style: context.outlinedButtonStyle,
                                    onPressed: () {
                                      appointmentController.addDescription(
                                        index,
                                      );
                                    },
                                    child: Text(
                                      'done'.tr,
                                      style: context.bodyMeduim,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Card(
                color: context.primarycolor.withAlpha(50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FaIcon(
                      size: context.iconSize,
                      FontAwesomeIcons.tooth,
                      color: whitecolor,
                    ),
                    Text(
                      appointmentController.teethAdd[index]['number'],
                      style: context.bodyMeduim,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
