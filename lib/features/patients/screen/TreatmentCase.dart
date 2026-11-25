import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/shared/widget/card_treatment.dart';
import 'package:mysen/features/shared/widget/appointment_show.dart';
import 'package:mysen/features/shared/widget/backed.dart';
import 'package:mysen/features/patients/controller/treatment_patient_controller.dart';
import 'package:mysen/features/shared/model/doctorforpatient.dart';

class TreatmentCaseScreenPatinet extends StatelessWidget {
  TreatmentCaseScreenPatinet({super.key, required this.dp});
  final Doctorforpatient dp;
  final TreatmentPatientController treatmentController = Get.put(
    TreatmentPatientController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primarycolor,
      appBar: AppBar(
        toolbarHeight: context.mediaSize.shortestSide * .15,
        leadingWidth: context.mediaSize.shortestSide * .15,

        leading: const Backed(),
        title: Text(dp.fullName, style: context.titleLarge),
        centerTitle: true,

        backgroundColor: context.primarycolor,
      ),
      body: Obx(() {
        return treatmentController.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: context.primaryContainer,
                ),
              )
            : ListView.builder(
                itemCount: treatmentController.treatmentCase.length,
                itemBuilder: (BuildContext context, int index) {
                  final treatment = treatmentController.treatmentCase[index];

                  return CardTreatment(
                    treatment: treatment,
                    delete: null,
                    leading: IconButton(
                      style: context.iconButtonStyle,
                      onPressed: () {
                        Utils.showMyDialog(
                          context: context,
                          child: Obx(
                            () => AppointmentShow(
                              appointments: treatmentController
                                  .appointmentsLeading(treatment),
                              phone: null,

                              colorized: treatmentController.colorizedLeading(
                                treatment.id,
                              ),
                              treatment: treatment,
                              childAppointment: const SizedBox.shrink(),
                              payPaid: treatmentController.payPaid(treatment),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.bookmark_added),
                    ),
                  );
                },
              );
      }),
    );
  }
}
