import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:mysen/core/utiles.dart';

class WidgetLanguage extends StatelessWidget {
  const WidgetLanguage({
    super.key,
    required this.onPressedAr,
    required this.onPressedEng,
  });

  final void Function() onPressedAr;
  final void Function() onPressedEng;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: context.mediaSize.shortestSide * .05,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Chose Language'.tr, style: context.bodyMeduim),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              style: context.iconButtonStyle?.copyWith(
                backgroundColor: WidgetStatePropertyAll(
                  context.primaryContainer,
                ),
              ),
              onPressed: onPressedAr,
              child: Text('Arabia'.tr),
            ),
            OutlinedButton(
              style: context.iconButtonStyle?.copyWith(
                backgroundColor: WidgetStatePropertyAll(
                  context.primaryContainer,
                ),
              ),
              onPressed: onPressedEng,
              child: Text('English'.tr),
            ),
          ],
        ),
      ],
    );
  }
}
