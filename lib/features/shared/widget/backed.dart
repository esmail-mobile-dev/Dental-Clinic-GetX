import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:mysen/core/utiles.dart';

class Backed extends StatelessWidget {
  const Backed({super.key, this.leftDirction = false});
  final bool leftDirction;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: context.iconButtonStyle,
      onPressed: () {
        if (Get.isOverlaysOpen || Get.key.currentState?.canPop() == true) {
          Get.back();
        }
      },
      icon: Icon(leftDirction ? Icons.arrow_forward : Icons.arrow_back),
    );
  }
}
