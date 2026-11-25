import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysen/core/utiles.dart';

class Alert extends StatelessWidget {
  const Alert({
    super.key,
    required this.confirme,
    required this.title,
    required this.isLoading,
  });

  final String title;
  final void Function() confirme;
  final RxBool isLoading;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Obx(
        () => isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: context.primaryContainer,
                ),
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  Text(title, style: context.bodyMeduim),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: context.mediaSize.shortestSide * .02,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Expanded(flex: 1, child: SizedBox.shrink()),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    if (Get.isOverlaysOpen ||
                                        Get.key.currentState?.canPop() ==
                                            true) {
                                      Get.back();
                                    }
                                  },
                                  child: Text(
                                    "cancel".tr,
                                    style: context.bodyMeduim?.copyWith(
                                      color: context.primaryContainer,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: confirme,
                                  child: Text(
                                    "ok".tr,
                                    style: context.bodyMeduim?.copyWith(
                                      color: context.primaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
