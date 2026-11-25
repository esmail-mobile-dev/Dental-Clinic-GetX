import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/error.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/services/doctorservices.dart';
import 'package:mysen/features/shared/model/doctor.dart';
import 'package:mysen/features/shared/services/sharedprefrenceservice.dart';
import 'package:mysen/features/shared/services/sql.dart';
import 'package:mysen/features/shared/widget/my_form_textfiled.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Doctoreditcontroller extends GetxController {
  RxBool isLoading = false.obs;
  //TextEditingController
  TextEditingController equlatificationsController = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();
  TextEditingController whatsAppcontoller = TextEditingController();
  //global Key
  GlobalKey<FormState> formKeyPhone = GlobalKey();
  GlobalKey<FormState> formKeyEq = GlobalKey();
  GlobalKey<FormState> formKeyLocation = GlobalKey();

  String phone = '';
  final ImagePicker imagePicker = ImagePicker();
  File? file;
  RxList<String> eq = <String>[].obs;
  Doctor? doctor;
  Doctorservices doctorservices = Doctorservices();
  DatabaseHelper sql = DatabaseHelper.instance;
  late InternetService internetService;
  final sharedPref = Get.find<SharedPrefService>();
  RxBool isworkState = true.obs;
  final remainingSeconds = 0.obs;
  Timer? workTimer;

  Future<void> fetchDoctor() async {
    try {
      isLoading.value = true;
      final dsql = await sql.queryAll('doctor');

      doctor = dsql.isEmpty ? null : Doctor.fromMapSql(dsql.first);
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> getImage() async {
    if (!await internetService.checkNow()) {
      ErrorHndel.handleError(ErrorType.internet);

      return;
    }
    final XFile? xFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (xFile != null) {
      file = File(xFile.path);
    }
    update();
  }

  Future<void> uploadImage(File? file) async {
    try {
      isLoading.value = true;

      if (file != null && doctor != null) {
        final storagePath = '${doctor?.id}/image';

        await client.storage
            .from('upfile')
            .upload(
              storagePath,
              file,
              fileOptions: const FileOptions(upsert: true),
            );

        final imgUrl = client.storage.from('upfile').getPublicUrl(storagePath);

        final newUrl = "$imgUrl?t=${DateTime.now().millisecondsSinceEpoch}";

        await doctorservices.updateDoctor(doctor!.copyWith(imgUrl: newUrl));

        doctor = doctor?.copyWith(imgUrl: newUrl);
        await sql.update('doctor', {'imgUrl': newUrl}, doctor!.id!);
        update();
      }
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (_) {
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void fetchEq() {
    if (doctor != null && doctor?.equlatifications != null) {
      eq.assignAll(doctor!.equlatifications!);
    }
  }

  void addEq() {
    if (!formKeyEq.currentState!.validate()) {
      return;
    }
    eq.add(equlatificationsController.text);
  }

  Future<void> updateDoctor(
    Doctor? doctorUpdate,
    Validate? validate, {
    bool isWorks = false,
  }) async {
    try {
      if (doctor == null) {
        return;
      }

      if (validate == Validate.phone) {
        if (!formKeyPhone.currentState!.validate()) {
          return;
        }
      }

      if (validate == Validate.location) {
        if (!formKeyLocation.currentState!.validate()) {
          return;
        }
      }

      if (!await internetService.checkNow()) {
        ErrorHndel.handleError(ErrorType.internet);

        return;
      }

      isLoading.value = true;
      await doctorservices
          .updateDoctor(doctorUpdate!)
          .timeout(const Duration(seconds: duration15));
      await sql.delete('doctor', doctor!.id!);

      await sql.insert('doctor', doctorUpdate.toMapSql());
      final dsql = await sql.queryAll('doctor');
      doctor = Doctor.fromMapSql(dsql.first);

      clearController();
      if (!isWorks) {
        back();
      }
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (_) {
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {
      isLoading.value = false;
    }
  }

  void back() {
    if (Get.isOverlaysOpen || Get.key.currentState?.canPop() == true) {
      Get.back();
    }
  }

  Future<void> updateDoctorWorking(bool isWorking) async {
    try {
      if (!isworkState.value) {
        return;
      }
      if (!await internetService.checkNow()) {
        ErrorHndel.handleError(ErrorType.internet);

        return;
      }

      await updateDoctor(
        doctor?.copyWith(isWorking: isWorking),
        null,
        isWorks: true,
      );
      isworkState.value = false;
      remainingSeconds.value = 120;

      workTimer?.cancel();

      workTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (remainingSeconds.value <= 1) {
          timer.cancel();
          remainingSeconds.value = 0;
          isworkState.value = true;
        } else {
          remainingSeconds.value--;
        }
      });

      back();
      MessageHandle.handleMessage(MessageType.isdoctorWork);
    } catch (_) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {
      update();
    }
  }

  void clearController() {
    equlatificationsController.clear();
    whatsAppcontoller.clear();
    locationcontroller.clear();
  }

  void setNumber() {
    phone = doctor?.phone['phone'];
    whatsAppcontoller.text = doctor?.phone['whatsApp'];
  }

  Future<void> fetchAll() async {
    await fetchDoctor();
    fetchEq();
    setNumber();
  }

  @override
  void onInit() {
    internetService = InternetService();

    fetchAll();
    super.onInit();
  }

  @override
  void onClose() {
    equlatificationsController.dispose();
    locationcontroller.dispose();
    whatsAppcontoller.dispose();
    internetService.dispose();
    workTimer?.cancel();
    super.onClose();
  }
}
