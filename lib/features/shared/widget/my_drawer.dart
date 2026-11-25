import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/shared/widget/card_drawer.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, this.onPressedSigOut, required this.children});

  final Function()? onPressedSigOut;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shadowColor: blackcolor,
      width: context.mediaSize.width * .7,
      backgroundColor: context.primarycolor,
      child: Column(
        children: [
          DrawerHeader(
            child: Center(child: Text('My Sen', style: context.titleLarge)),
          ),
          Expanded(flex: 5, child: Column(children: children)),
          Expanded(
            child: CardDrawer(
              title: 'signOut'.tr,
              iconData: Icons.logout,
              onTap: onPressedSigOut,
            ),
          ),
        ],
      ),
    );
  }
}
