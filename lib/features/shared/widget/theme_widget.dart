import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/shared/widget/backed.dart';

class ThemeWidget extends StatelessWidget {
  final void Function(int index) onPressedCall;

  const ThemeWidget({super.key, required this.onPressedCall});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: context.mediaSize.shortestSide * .05,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            const Backed(),

            Center(child: Text('set theme'.tr, style: context.titleLarge)),
          ],
        ),
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
            ),
            itemCount: Utils.listTheme.length,
            itemBuilder: (BuildContext context, int index) {
              final Color primary = Utils.listTheme[index]['primary'];
              final Color primaryContainer =
                  Utils.listTheme[index]['primaryContainer'];

              return InkWell(
                onTap: () {
                  onPressedCall(index);
                },
                child: Transform.scale(
                  scale: .5,
                  child: Card(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Expanded(
                          child: ColoredBox(
                            color: primary,

                            child: const SizedBox.expand(),
                          ),
                        ),
                        Expanded(
                          child: ColoredBox(
                            color: primaryContainer,

                            child: const SizedBox.expand(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
