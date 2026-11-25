import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:mysen/core/approut.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/doctorcontroller.dart';
import 'package:mysen/features/doctor/widget/form_add_patient.dart';

class BottomNavgiationBarDoctor extends StatelessWidget {
  const BottomNavgiationBarDoctor({super.key, required this.doctorcontroller});

  final Doctorcontroller doctorcontroller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(bottom: context.padding * 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Card(
            elevation: elevation,
            color: context.primaryContainer,
            child: IconButton(
              style: context.iconButtonStyle,
              onPressed: () {
                Utils.showMyDialog(
                  widthFactor: context.mediaSize.width < 600 ? 1 : .9,
                  heightFactor: 1,
                  context: context,
                  child: FormAddpatient(
                    color: context.primaryContainer,
                    title: "create patients".tr,
                    controllerName: doctorcontroller.nameController,
                    controllerPhone: doctorcontroller.phoneController,

                    onPressed: doctorcontroller.addPatientForDoctor,

                    doctorcontroller: doctorcontroller,
                    controllerNickName: doctorcontroller.nickNamecontroller,
                  ),
                );
              },
              icon: Icon(Icons.add, color: context.primarycolor),
            ),
          ),
          Card(
            elevation: 2,
            color: context.primaryContainer,
            child: IconButton(
              style: context.iconButtonStyle,
              onPressed: () {
                doctorcontroller.rout(Approut.allreserve);
              },
              icon: Icon(
                Icons.view_timeline_outlined,
                color: context.primarycolor,
              ),
            ),
          ),
          Card(
            clipBehavior: Clip.none,
            elevation: 2,
            color: context.primaryContainer,
            child: Badge(
              offset: Offset(context.mediaSize.shortestSide * .08, 0),
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(3),
              label: Obx(
                () => Text(
                  doctorcontroller.isFetchRequest.value
                      ? doctorcontroller.requestRservationForNotfication.length
                            .toString()
                      : 'x',
                  style: context.bodyMeduim,
                ),
              ),
              backgroundColor: context.colorScheme.error,
              child: IconButton(
                style: context.iconButtonStyle,
                onPressed: () {
                  doctorcontroller.rout(Approut.notfictions);
                },
                icon: Icon(Icons.notifications, color: context.primarycolor),
              ),
            ),
          ),
          Obx(
            () => Card(
              elevation: 2,
              color: context.primaryContainer,
              child: IconButton(
                style: context.iconButtonStyle,
                onPressed: () {
                  doctorcontroller.isSearch.value =
                      !doctorcontroller.isSearch.value;
                },
                icon: Icon(
                  color: context.primarycolor,
                  doctorcontroller.isSearch.value
                      ? Icons.search_off
                      : Icons.search_rounded,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
