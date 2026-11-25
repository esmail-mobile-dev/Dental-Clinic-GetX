import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/appointment_controller.dart';
import 'package:mysen/features/doctor/controller/treatment_controller.dart';
import 'package:mysen/features/doctor/screen/appointment_dialog.dart';
import 'package:mysen/features/shared/widget/card_treatment.dart';
import 'package:mysen/features/doctor/widget/child_phone.dart';
import 'package:mysen/features/shared/model/patientsfordoctor.dart';
import 'package:mysen/features/shared/widget/alert.dart';
import 'package:mysen/features/shared/widget/appointment_show.dart';

class BodyTreatment extends StatelessWidget {
  const BodyTreatment({
    super.key,
    required this.treatmentController,
    required this.dp,
    required this.appointmentController,
  });

  final TreatmentController treatmentController;
  final Patientsfordoctor dp;
  final AppointmentController appointmentController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final RxList treatmens = treatmentController.treatmentCaseActive
          .where((p0) => p0.doctorPatientID == dp.id)
          .toList()
          .obs;
      return ListView.builder(
        itemCount: treatmens.length,
        itemBuilder: (BuildContext context, int index) {
          final treatment = treatmens[index];

          return CardTreatment(
            treatment: treatment,
            delete: IconButton(
              style: context.iconButtonStyle,
              onPressed: () {
                Utils.showMyDialog(
                  context: context,
                  heightFactor: .3,
                  widthFactor: context.mediaSize.width > 600 ? 0.6 : .8,

                  colorDialog: context.colorScheme.error,
                  child: Alert(
                    confirme: () {
                      treatmentController.deleteTreatmentCase(treatment);
                    },
                    title: 'title delet'.tr,
                    isLoading: treatmentController.isLoading,
                  ),
                );
              },
              icon: const Icon(Icons.delete),
            ),

            leading: SizedBox(
              width: context.mediaSize.width * .2,
              child: Row(
                children: [
                  Expanded(
                    child: IconButton(
                      style: context.iconButtonStyle,
                      onPressed: () {
                        Utils.showMyDialog(
                          context: context,
                          child: Obx(
                            () => AppointmentShow(
                              appointments: appointmentController
                                  .appointMentsTreatemnt(treatment),

                              phone: dp.phone,

                              colorized: appointmentController.colorizedLeading(
                                treatment.id,
                              ),
                              treatment: treatment,
                              childAppointment: ChildPhone(phone: dp.phone),
                              payPaid: appointmentController.payPaid(treatment),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.bookmark_added),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      style: context.iconButtonStyle,
                      onPressed: () {
                        Get.to(
                          transition: Transition.noTransition,
                          () => AppointmetDialog(
                            treatmentCase: treatment,
                            appointmentController: appointmentController,
                          ),
                        );
                      },

                      icon: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
