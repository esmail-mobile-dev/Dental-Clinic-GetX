import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/error.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/shared/model/treatment_case.dart';
import 'package:mysen/features/shared/services/sharedprefrenceservice.dart';
import 'package:mysen/features/shared/services/sql.dart';
import 'package:mysen/features/shared/services/treatmentcaseservices.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TreatmentController extends GetxController {
  //textcontroller

  Treatmentcaseservices treatmentcaseservices = Treatmentcaseservices();
  TextEditingController totalPrice = TextEditingController();

  final RxList<TreatmentCase> _treatmentCase = <TreatmentCase>[].obs;
  RxList<TreatmentCase> get treatmentCaseActive => _treatmentCase
      .where((p0) => p0.treatmentSatus == TreatmentSatus.active)
      .toList()
      .obs;
  RxList<TreatmentCase> get treatmentCaseCanceled => _treatmentCase
      .where((p0) => p0.treatmentSatus == TreatmentSatus.canceled)
      .toList()
      .obs;

  RxBool isLoading = false.obs;

  // globalKey
  final GlobalKey<FormState> formKeyTreatment = GlobalKey();
  DatabaseHelper sql = DatabaseHelper.instance;
  late InternetService internetService;
  final sharedPref = Get.find<SharedPrefService>();

  Future<void> loadTreatmentCaseFromSql() async {
    _treatmentCase.clear();
    final treatmentCaseSql = await sql.queryAll('treatmentCase');
    for (var treatment in treatmentCaseSql) {
      _treatmentCase.add(TreatmentCase.fromMapSql(treatment));
    }
  }

  Future<void> fetchTreatmentCase() async {
    try {
      final treatmentCaseSql = await sql.queryAll('treatmentCase');
      loadTreatmentCaseFromSql();
      if (!await internetService.checkNow()) {
        return;
      }

      if (treatmentCaseSql.isEmpty) {
        isLoading.value = true;
        final treatment = await treatmentcaseservices
            .fetchTreatmentCase()
            .order('createdAt', ascending: true)
            .timeout(const Duration(seconds: duration15));
        _treatmentCase.assignAll(
          treatment.map((a) => TreatmentCase.fromMap(a)),
        );

        for (var tr in _treatmentCase) {
          await sql.insert('treatmentCase', tr.toMapSql());
        }
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

  Future<void> addTreatmentCase(String dpID) async {
    try {
      if (!formKeyTreatment.currentState!.validate()) {
        return;
      }

      if (!await internetService.checkNow()) {
        ErrorHndel.handleError(ErrorType.internet);

        return;
      }

      final treatment = TreatmentCase(
        id: '',
        doctorPatientID: dpID,
        totalPrice: int.parse(totalPrice.text),
        treatmentSatus: TreatmentSatus.active,
      );

      isLoading.value = true;
      final tr = await treatmentcaseservices
          .addTreatmentCase(treatment)
          .timeout(const Duration(seconds: duration15));

      await sql.insert('treatmentCase', TreatmentCase.fromMap(tr).toMapSql());

      loadTreatmentCaseFromSql();

      totalPrice.clear();
      back();
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (e) {
      if (e.code == '42501') {
        ErrorHndel.handleError(ErrorType.rls);
      }
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTreatmentCase(TreatmentCase treatment) async {
    try {
      if (!await internetService.checkNow()) {
        ErrorHndel.handleError(ErrorType.internet);

        return;
      }

      isLoading.value = true;
      final response = await client.rpc(
        'cancel_or_delete_treatment_case',
        params: {'p_treatment_case_id': treatment.id},
      );

      if (response == TreatmentSatus.canceled.name) {
        await sql.update('treatmentCase', {
          'treatmentStatus': TreatmentSatus.canceled.name,
        }, treatment.id);
      }
      if (response == TreatmentSatus.deleted.name) {
        await sql.delete('treatmentCase', treatment.id);
      }

      loadTreatmentCaseFromSql();

      back();
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (e) {
      if (e.code == '42501') {
        ErrorHndel.handleError(ErrorType.rls);
      }
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTreatmentCase(TreatmentCase treatment) async {
    try {
      if (!await internetService.checkNow()) {
        ErrorHndel.handleError(ErrorType.internet);

        return;
      }

      isLoading.value = true;
      await treatmentcaseservices.updateTreatmentCase(
        treatment.copyWith(treatmentSatus: TreatmentSatus.active),
      );

      await sql.update('treatmentCase', {
        'treatmentStatus': TreatmentSatus.active.name,
      }, treatment.id);

      loadTreatmentCaseFromSql();

      back();
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (e) {
      if (e.code == '42501') {
        ErrorHndel.handleError(ErrorType.rls);
      }
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

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      internetService = InternetService();
      fetchTreatmentCase();
    });

    super.onInit();
  }

  @override
  void onClose() {
    internetService.dispose();
    totalPrice.dispose();
    super.onClose();
  }
}
