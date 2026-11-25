import 'package:flutter/material.dart';

import 'package:get/instance_manager.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/shared/controller/logincontroller.dart';
import 'package:mysen/features/shared/widget/form_login.dart';

class Login extends StatelessWidget {
  Login({super.key});
  final Logincontroller logincontroller = Get.put<Logincontroller>(
    Logincontroller(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primarycolor,
      body: SizedBox.expand(child: Formlogin(logincontroller: logincontroller)),
    );
  }
}
