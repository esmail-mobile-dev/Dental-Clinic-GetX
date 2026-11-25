import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/doctorcontroller.dart';
import 'package:mysen/features/doctor/screen/treatment_case.dart';
import 'package:mysen/features/doctor/widget/search.dart';
import 'package:mysen/features/shared/widget/alert.dart';
import 'package:mysen/features/shared/widget/card_dp.dart';

class BodyDoctor extends StatelessWidget {
  const BodyDoctor({super.key, required this.doctorcontroller});
  final Doctorcontroller doctorcontroller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => doctorcontroller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: context.primaryContainer,
                ),
              )
            : Column(
                children: [
                  Search(doctorcontroller: doctorcontroller),

                  Expanded(
                    child: ListView.builder(
                      itemCount: doctorcontroller.patientsfordoctor.length,
                      itemBuilder: (BuildContext context, int index) {
                        final dp = doctorcontroller.patientsfordoctor[index];

                        return CardPatient(
                          title: Text(
                            dp.fullName,
                            style: context.bodyLarge,
                            textAlign: TextAlign.center,
                          ),

                          trailing: IconButton(
                            style: context.iconButtonStyle,

                            onPressed: () {
                              Utils.showMyDialog(
                                heightFactor: .3,
                                widthFactor: context.mediaSize.width > 600
                                    ? 0.6
                                    : .8,

                                colorDialog: context.colorScheme.error,
                                context: context,
                                child: Alert(
                                  isLoading: doctorcontroller.isLoading,
                                  confirme: () => doctorcontroller
                                      .deletePatintForDoctor(dp.id),

                                  title: 'title delet'.tr,
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.delete,
                              color: context.primaryContainer,
                            ),
                          ),

                          leading: IconButton(
                            style: context.iconButtonStyle,
                            onPressed: () {
                              Get.to(
                                transition: Transition.noTransition,
                                () => TreatmentCaseScreenDoctor(dp: dp),
                              );
                            },
                            icon: const Icon(Icons.bookmark_sharp),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
