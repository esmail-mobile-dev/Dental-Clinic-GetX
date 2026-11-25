import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/controller/doctoreditcontroller.dart';
import 'package:mysen/features/shared/widget/close.dart';
import 'package:mysen/features/shared/widget/my_form_textfiled.dart';

class DoctorEditEqu extends StatelessWidget {
  const DoctorEditEqu({super.key, required this.doctoreditcontroller});

  final Doctoreditcontroller doctoreditcontroller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.mediaSize.shortestSide * .02),
      child: Column(
        spacing: context.mediaSize.shortestSide * .05,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const Closed(),
              Text('editQualifications'.tr, style: context.titleLarge),
            ],
          ),
          Form(
            key: doctoreditcontroller.formKeyEq,
            child: Row(
              children: [
                Expanded(
                  child: MytexFormFiled(
                    filled: false,
                    controller: doctoreditcontroller.equlatificationsController,
                    label: "equalzation".tr,
                    validate: Validate.equalization,
                  ),
                ),
                IconButton(
                  style: context.iconButtonStyle,
                  onPressed: () {
                    doctoreditcontroller.addEq();
                  },
                  icon: Icon(
                    size: context.iconSize,
                    Icons.add,
                    color: whitecolor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: doctoreditcontroller.eq.length,

                itemBuilder: (BuildContext context, int index) {
                  final eq = doctoreditcontroller.eq[index];
                  return ListTile(
                    trailing: IconButton(
                      style: context.iconButtonStyle,
                      onPressed: () {
                        doctoreditcontroller.eq.removeAt(index);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    leading: Icon(
                      Icons.star,
                      size: context.iconSize,
                      color: context.primaryContainer,
                    ),

                    title: Text(style: context.bodyMeduim, eq),
                  );
                },
              ),
            ),
          ),
          Center(
            child: FractionallySizedBox(
              widthFactor: .8,
              child: Obx(
                () =>
                    OutlinedButton(
                      style: context.outlinedButtonStyle,
                      onPressed: () {
                        doctoreditcontroller.updateDoctor(
                          doctoreditcontroller.doctor?.copyWith(
                            equlatifications: doctoreditcontroller.eq,
                          ),
                          Validate.equalization,
                        );
                      },
                      child: Text('done'.tr, style: context.bodyMeduim),
                    ).loading(
                      doctoreditcontroller.isLoading.value,
                      context.primaryContainer,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
