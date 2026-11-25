import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/appointment_controller.dart';
import 'package:mysen/features/doctor/widget/description_button.dart';
import 'package:mysen/features/doctor/widget/widget_teeth_flowchart.dart';
import 'package:mysen/features/shared/widget/close.dart';
import 'package:mysen/features/shared/widget/teeth_floawchart_button.dart';

class TeethButton extends StatelessWidget {
  final AppointmentController appointmentController;
  const TeethButton({super.key, required this.appointmentController});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Utils.showMyDialog(
          context: context,
          child: Obx(
            () => TeethFlowchart(
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
                            const Closed(),
                            Text('description'.tr, style: context.titleLarge),
                          ],
                        ),

                        DescriptionsButton(
                          appointmentController: appointmentController,
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.description_sharp),
              ),
              ignoring: false,
              isButtonAddTeeth: true,
              onChangeSelectTeeth: (p0) {
                appointmentController.onChangeSelectTeeth(p0);
              },
              colorized: appointmentController.colorized(
                appointmentController.teethAdd,
              ),

              widgetTeethButton: WidgetTeethFlowChart(
                appointmentController: appointmentController,
              ),
              onPressedAdd: () {
                appointmentController.addTeethAdd();
              },
              initiallySelected: appointmentController.initiallySelectedTeeth(),
            ),
          ),
        );
      },
      icon: FaIcon(
        size: context.mediaSize.shortestSide * .045,
        FontAwesomeIcons.tooth,
        color: context.primaryContainer,
      ),
    );
  }
}
