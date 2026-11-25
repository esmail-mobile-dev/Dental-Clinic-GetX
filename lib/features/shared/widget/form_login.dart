import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/shared/controller/logincontroller.dart';
import 'package:mysen/features/shared/widget/my_form_textfiled.dart';

class Formlogin extends StatelessWidget {
  const Formlogin({super.key, required this.logincontroller});

  final Logincontroller logincontroller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),

        controller: logincontroller.pageController,
        children: [
          FractionallySizedBox(
            widthFactor: .9,
            heightFactor: .3,
            child: Card(
              elevation: elevation,
              color: context.primarycolor,
              child: Column(
                spacing: context.spacing,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      logincontroller.pageController.jumpToPage(1);
                      logincontroller.clearCpntroller();
                    },
                    style: context.iconButtonStyle?.copyWith(
                      backgroundColor: WidgetStatePropertyAll(
                        context.primaryContainer,
                      ),
                    ),
                    child: Text(
                      'login'.tr,
                      style: context.bodySmall?.copyWith(
                        color: context.primarycolor,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      logincontroller.pageController.jumpToPage(2);
                      logincontroller.clearCpntroller();
                    },
                    style: context.iconButtonStyle?.copyWith(
                      backgroundColor: WidgetStatePropertyAll(
                        context.primaryContainer,
                      ),
                    ),
                    child: Text(
                      'signin'.tr,
                      style: context.bodySmall?.copyWith(
                        color: context.primarycolor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: .9,
            heightFactor: .3,
            child: Card(
              elevation: elevation,
              color: context.primarycolor,
              child: Form(
                key: logincontroller.loginKey,
                child: Column(
                  spacing: context.spacing,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: AlignmentGeometry.centerLeft,

                      children: [
                        IconButton(
                          style: context.iconButtonStyle,

                          onPressed: () {
                            logincontroller.jupmPage(0);
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                        Center(
                          child: Text('login'.tr, style: context.bodyLarge),
                        ),
                      ],
                    ),

                    FractionallySizedBox(
                      widthFactor: .8,
                      child: MytexFormFiled(
                        fillColor: context.primaryContainer.withAlpha(50),
                        controller: logincontroller.phone,
                        label: "phone".tr,
                        prefixText: '966+:',
                        validate: Validate.phone,
                        keyboardType: TextInputType.number,
                      ),
                    ),

                    Obx(
                      () => FractionallySizedBox(
                        widthFactor: .8,
                        child:
                            OutlinedButton(
                              onPressed: () {
                                logincontroller.signin();
                              },
                              style: context.iconButtonStyle?.copyWith(
                                backgroundColor: WidgetStatePropertyAll(
                                  context.primaryContainer,
                                ),
                              ),
                              child: Text(
                                'done'.tr,
                                style: context.bodyMeduim?.copyWith(
                                  color: context.primarycolor,
                                ),
                              ),
                            ).loading(
                              logincontroller.isloading.value,
                              context.primaryContainer,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          FractionallySizedBox(
            widthFactor: .9,
            heightFactor: .3,
            child: Card(
              elevation: elevation,
              color: context.primarycolor,
              child: Form(
                key: logincontroller.siginKey,
                child: Column(
                  spacing: context.spacing,

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: AlignmentGeometry.centerLeft,
                      children: [
                        IconButton(
                          style: context.iconButtonStyle,

                          onPressed: () {
                            logincontroller.jupmPage(0);
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                        Center(
                          child: Text('signin'.tr, style: context.bodyLarge),
                        ),
                      ],
                    ),
                    FractionallySizedBox(
                      widthFactor: .8,
                      child: MytexFormFiled(
                        fillColor: context.primaryContainer.withAlpha(50),

                        controller: logincontroller.phone,
                        label: "phone".tr,
                        validate: Validate.phone,
                        keyboardType: TextInputType.number,
                        prefixText: '966+:',
                      ),
                    ),
                    Obx(
                      () => FractionallySizedBox(
                        widthFactor: .8,
                        child:
                            OutlinedButton(
                              onPressed: () {
                                logincontroller.signupFirst();
                              },
                              style: context.iconButtonStyle?.copyWith(
                                backgroundColor: WidgetStatePropertyAll(
                                  context.primaryContainer,
                                ),
                              ),
                              child: Text(
                                'done'.tr,
                                style: context.bodyMeduim?.copyWith(
                                  color: context.primarycolor,
                                ),
                              ),
                            ).loading(
                              logincontroller.isloading.value,
                              context.primaryContainer,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: FractionallySizedBox(
              widthFactor: .9,
              heightFactor: .3,
              child: Obx(
                () => Card(
                  elevation: elevation,
                  color: context.primarycolor,

                  child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: [
                          Stack(
                            children: [
                              Center(
                                child: Text(
                                  'Verify'.tr,
                                  style: context.bodyLarge,
                                ),
                              ),

                              if (logincontroller.isback.value)
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: IconButton(
                                    style: context.iconButtonStyle,
                                    onPressed: () {
                                      logincontroller.jupmPage(0);
                                      logincontroller.clearBoxVerfiy();
                                    },
                                    icon: const Icon(Icons.arrow_back),
                                  ),
                                ),
                            ],
                          ),

                          // OTP fields
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                4,
                                (index) => _buildCodeField(index, context),
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "messageResend".tr,
                                style: context.bodyLarge,
                              ),
                              TextButton(
                                onPressed: logincontroller.resendCode,
                                child: Text(
                                  'Resend'.tr,
                                  style: context.bodyMeduim?.copyWith(
                                    color: context.primaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ).loading(
                        logincontroller.isloading.value,
                        context.primaryContainer,
                      ),
                ),
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: .9,
            heightFactor: .3,
            child: Card(
              elevation: elevation,
              color: context.primarycolor,
              child: Form(
                key: logincontroller.siginCompleteKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Add Name', style: context.bodyLarge),

                    FractionallySizedBox(
                      widthFactor: .8,
                      child: MytexFormFiled(
                        fillColor: context.primaryContainer.withAlpha(50),
                        controller: logincontroller.name,
                        label: "name".tr,
                        validate: Validate.name,
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: .8,

                      child: MytexFormFiled(
                        fillColor: context.primaryContainer.withAlpha(50),
                        controller: logincontroller.nickName,
                        label: "nickName".tr,
                        validate: Validate.nickName,
                      ),
                    ),

                    Obx(
                      () => FractionallySizedBox(
                        widthFactor: .8,

                        child:
                            OutlinedButton(
                              onPressed: () {
                                logincontroller.signUpPatientComplete();
                              },
                              style: context.iconButtonStyle?.copyWith(
                                backgroundColor: WidgetStatePropertyAll(
                                  context.primaryContainer,
                                ),
                              ),
                              child: Text(
                                'done'.tr,
                                style: context.bodyMeduim?.copyWith(
                                  color: context.primarycolor,
                                ),
                              ),
                            ).loading(
                              logincontroller.isloading.value,
                              context.primaryContainer,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeField(int index, BuildContext context) {
    return SizedBox(
      width: 62,
      height: 62,
      child: TextField(
        controller: logincontroller.controllers[index],
        focusNode: logincontroller.focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: context.primaryContainer,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: context.colorScheme.primary,
              width: 2,
            ),
          ),
        ),
        onChanged: (value) {
          logincontroller.onChanged(value, index);
        },
      ),
    );
  }
}
