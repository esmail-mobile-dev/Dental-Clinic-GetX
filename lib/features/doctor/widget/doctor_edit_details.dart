import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/doctoreditcontroller.dart';
import 'package:mysen/features/doctor/widget/doctor_edit_equ.dart';
import 'package:mysen/features/doctor/widget/doctor_edit_numbers.dart';
import 'package:mysen/features/doctor/widget/doctor_edit_location.dart';
import 'package:mysen/features/shared/widget/my_form_textfiled.dart';

class DoctorEditDetails extends StatelessWidget {
  const DoctorEditDetails({super.key, required this.doctoreditcontroller});

  final Doctoreditcontroller doctoreditcontroller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Obx(
          () =>
              OutlinedButton.icon(
                icon: Icon(
                  Icons.add,
                  size: context.iconSize,

                  color: context.primaryContainer,
                ),
                style: context.outlinedButtonStyle?.copyWith(
                  minimumSize: WidgetStatePropertyAll(
                    Size(
                      context.mediaSize.width / 4,
                      context.mediaSize.shortestSide * .1,
                    ),
                  ),
                ),
                onPressed: () async {
                  await doctoreditcontroller.getImage();
                  doctoreditcontroller.uploadImage(doctoreditcontroller.file);
                },
                label: Text(
                  'add image'.tr,
                  style: context.bodySmall?.copyWith(color: whitecolor),
                ),
              ).loading(
                doctoreditcontroller.isLoading.value,
                context.primaryContainer,
              ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              style: context.iconButtonStyle,
              onPressed: () async {
                Utils.showMyDialog(
                  widthFactor: .8,

                  heightFactor: 1,

                  context: context,
                  child: LocationDoctorEdit(
                    doctoreditcontroller: doctoreditcontroller,
                  ),
                );
              },
              icon: const Icon(Icons.location_on),
            ),
            ExpandIcon(
              size: context.iconSize,
              color: context.primaryContainer,
              onPressed: (value) {
                doctoreditcontroller.fetchEq();

                Utils.showMyDialog(
                  context: context,
                  child: DoctorEditEqu(
                    doctoreditcontroller: doctoreditcontroller,
                  ),
                );
              },
            ),
            IconButton(
              style: context.iconButtonStyle,
              onPressed: () {
                doctoreditcontroller.setNumber();
                Utils.showMyDialog(
                  widthFactor: .8,
                  context: context,
                  child: Form(
                    key: doctoreditcontroller.formKeyPhone,

                    child: Editnumbers(
                      title: 'editPhone'.tr,

                      phone: doctoreditcontroller.phone,
                      whats: doctoreditcontroller.whatsAppcontoller,
                      doctoreditcontroller: doctoreditcontroller,
                      onPressed: () {
                        doctoreditcontroller.updateDoctor(
                          doctoreditcontroller.doctor?.copyWith(
                            phone: {
                              'whatsApp':
                                  doctoreditcontroller.whatsAppcontoller.text,
                            },
                          ),
                          Validate.phone,
                        );
                      },
                      lablePhone: 'phone'.tr,
                      lableWhats: 'whatsApp'.tr,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.phone_android),
            ),
          ],
        ),
      ],
    );
  }
}
