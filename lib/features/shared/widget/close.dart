import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:mysen/core/utiles.dart';

class Closed extends StatelessWidget {
  const Closed({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        style: context.iconButtonStyle,
        onPressed: () {
          if (Get.isOverlaysOpen || Get.key.currentState?.canPop() == true) {
            Get.back();
          }
        },
        icon: const Icon(Icons.clear),
      ),
    );
  }
}
