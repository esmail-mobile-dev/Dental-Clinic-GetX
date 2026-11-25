import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/patients/controller/reservation_controller.dart';
import 'package:mysen/features/patients/screen/TreatmentCase.dart';
import 'package:mysen/features/shared/widget/alert.dart';
import 'package:mysen/features/shared/widget/card_dp.dart';

class BodyPatinet extends StatelessWidget {
  const BodyPatinet({super.key, required this.reservationcontroller});

  final Reservationcontroller reservationcontroller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => reservationcontroller.isLoading.value
          ? Center(
              child: CircularProgressIndicator(color: context.primaryContainer),
            )
          : RefreshIndicator(
              onRefresh: () async {
                reservationcontroller.refreshAll();
              },
              child: ListView.builder(
                itemCount: reservationcontroller.doctorsforpatient.length,
                itemBuilder: (BuildContext context, int index) {
                  final dp = reservationcontroller.doctorsforpatient[index];

                  return CardPatient(
                    title: Text(
                      textAlign: TextAlign.center,
                      style: context.bodyLarge,
                      reservationcontroller.doctorsforpatient[index].fullName,
                    ),

                    trailing: IconButton(
                      style: context.iconButtonStyle,
                      onPressed: () {
                        Utils.showMyDialog(
                          dismissible: true,
                          heightFactor: .3,
                          widthFactor: context.mediaSize.width > 600
                              ? 0.6
                              : .75,

                          colorDialog: context.colorScheme.error,
                          context: context,
                          child: Alert(
                            confirme: () {
                              reservationcontroller.back();
                              reservationcontroller.deleteDoctorForPatient(dp);
                            },
                            title: 'title delet'.tr,
                            isLoading: false.obs,
                          ),
                        );
                      },
                      icon: Icon(Icons.delete, color: context.primaryContainer),
                    ),

                    leading: IconButton(
                      style: context.iconButtonStyle,
                      onPressed: () {
                        Get.to(
                          transition: Transition.noTransition,
                          () => TreatmentCaseScreenPatinet(dp: dp),
                        );
                      },
                      icon: const Icon(Icons.bookmark),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
