import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mysen/core/approut.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/error.dart';
import 'package:mysen/core/localnotfication.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/services/doctorservices.dart';
import 'package:mysen/features/patients/services/patientsservices.dart';
import 'package:mysen/features/shared/model/doctor.dart';
import 'package:mysen/features/shared/model/patients.dart';
import 'package:mysen/features/shared/model/user.dart';
import 'package:mysen/features/shared/services/doctorpatientservices.dart';
import 'package:mysen/features/shared/services/logservices.dart';
import 'package:mysen/features/shared/services/sharedprefrenceservice.dart';
import 'package:mysen/features/shared/services/usermainservices.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Logincontroller extends GetxController {
  RxBool isloading = false.obs;
  RxBool isback = false.obs;

  PageController pageController = PageController();

  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  GlobalKey<FormState> siginKey = GlobalKey<FormState>();
  GlobalKey<FormState> siginCompleteKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController nickName = TextEditingController();
  TextEditingController phone = TextEditingController();

  String codeSend = '';

  UserDetailsservices userDetailsservices = UserDetailsservices();
  Logservices logservices = Logservices();
  Patientsservices patientsservices = Patientsservices();
  Doctorservices doctorservices = Doctorservices();
  Doctorpatientservices doctorpatientservices = Doctorpatientservices();

  late InternetService internetService;
  final List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List<FocusNode>.generate(
    4,
    (_) => FocusNode(),
  );
  String get code => controllers.map((e) => e.text).join();
  final SharedPrefService sharedPref = Get.find<SharedPrefService>();

  void onChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }

    if (code.length == 4) {
      signUpVerfy();
    }
  }

  Future<void> resendCode() async {
    isloading.value = true;
    if (phone.text.isEmpty) {
      isloading.value = false;
      return;
    }
    final List<String> code = phone.text.split('');
    code.shuffle();
    codeSend = code.sublist(0, 4).join();

    await LocalNotificationService().cancelAll();
    await LocalNotificationService().showInstantNotification(
      title: 'Code'.tr,
      body: codeSend,
    );
    isloading.value = false;
  }

  Future<void> roleRout(Role roleSet, String appRout) async {
    await sharedPref.setRole(roleSet);

    Get.offAllNamed(appRout);
  }

  void jupmPage(int page) {
    pageController.jumpToPage(page);
  }

  Future<void> signin() async {
    try {
      if (!await internetService.checkNow()) {
        ErrorHndel.handleError(ErrorType.internet);
      }
      if (!loginKey.currentState!.validate()) {
        return;
      }
      isloading.value = true;
      await logservices.signin('${phone.text}@gmail.com', phone.text);
      final user = await userDetailsservices.fetchUserByUserID().timeout(
        const Duration(seconds: duration15),
      );

      if (user == null) {
        jupmPage(4);
        return;
      }

      if (user['role'] == Role.doctor.name) {
        await roleRout(Role.doctor, Approut.doctor);
        return;
      }
      await roleRout(Role.user, Approut.mainscreen);

      return;
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);

      return;
    } on PostgrestException catch (_) {
      ErrorHndel.handleError(ErrorType.error);

      return;
    } on AuthApiException catch (_) {
      ErrorHndel.handleError(ErrorType.authlogin);

      return;
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {
      isloading.value = false;
    }
  }

  Future<void> signupFirst() async {
    try {
      isloading.value = true;
      if (!siginKey.currentState!.validate()) {
        return;
      }

      await Future.delayed(const Duration(seconds: 2));
      jupmPage(3);
      await Future.delayed(const Duration(seconds: 3));
      resendCode();
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {
      isloading.value = false;
    }
  }

  Future<void> signUpVerfy() async {
    try {
      isloading.value = true;
      if (code != codeSend) {
        clearBoxVerfiy();
        ErrorHndel.handleError(ErrorType.code);

        return;
      }

      await logservices.signup('${phone.text}@gmail.com', phone.text);
      final auth = client.auth;
      final doctor = await doctorservices.fetchDoctorByPhone(phone.text);

      if (doctor == null) {
        final patient = await patientsservices.fetchPatientByPhone(phone.text);
        if (patient == null) {
          jupmPage(4);
          return;
        }

        await userDetailsservices.upsertUserDetails(
          UserDetails(role: Role.user.name),
        );
        await patientsservices.updatePatient(
          Patient.fromMap(patient).copyWith(userID: auth.currentUser?.id),
        );
        await doctorpatientservices.updateIsDeletePatient(patient['id']);

        roleRout(Role.user, Approut.mainscreen);

        return;
      }

      await userDetailsservices.upsertUserDetails(
        UserDetails(role: Role.doctor.name),
      );
      await doctorservices.updateDoctor(
        Doctor.fromMap(doctor).copyWith(userID: auth.currentUser?.id),
      );
      roleRout(Role.doctor, Approut.doctor);
    } on AuthApiException catch (_) {
      ErrorHndel.handleError(ErrorType.authsign);
      isback.value = true;
    } on PostgrestException catch (_) {
      ErrorHndel.handleError(ErrorType.error);
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {
      isloading.value = false;
    }
  }

  Future<void> signUpPatientComplete() async {
    try {
      if (!siginCompleteKey.currentState!.validate()) {
        return;
      }
      isloading.value = true;
      await userDetailsservices.upsertUserDetails(
        UserDetails(role: Role.user.name),
      );
      await patientsservices.addPatient(
        Patient(
          fullName: ('${name.text.trim()} ${nickName.text.trim()}').replaceAll(
            RegExp(r'\s+'),
            ' ',
          ),
          phone: phone.text,

          userID: client.auth.currentUser?.id,
        ),
      );
      roleRout(Role.user, Approut.mainscreen);
    } on PostgrestException catch (_) {
      ErrorHndel.handleError(ErrorType.error);
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {
      isloading.value = false;
    }
  }

  void clearBoxVerfiy() {
    for (final controller in controllers) {
      controller.clear();
    }
    for (final focus in focusNodes) {
      focus.unfocus();
    }
  }

  clearCpntroller() {
    name.clear();
    nickName.clear();
    phone.clear();
  }

  @override
  void onInit() {
    internetService = InternetService();
    super.onInit();
  }

  @override
  void dispose() {
    pageController.dispose();
    name.dispose();
    nickName.dispose();
    phone.dispose();
    internetService.dispose();
    for (final controller in controllers) {
      controller.dispose();
    }

    for (final node in focusNodes) {
      node.dispose();
    }

    super.dispose();
  }
}
