import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/error.dart';
import 'package:mysen/core/localnotfication.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/doctor/services/doctorservices.dart';
import 'package:mysen/features/patients/services/patientsservices.dart';
import 'package:mysen/features/shared/model/doctor.dart';
import 'package:mysen/features/shared/model/patients.dart';
import 'package:mysen/features/shared/model/request_reservation.dart';
import 'package:mysen/features/shared/services/requsetreserveservices.dart';
import 'package:mysen/features/shared/services/sharedprefrenceservice.dart';
import 'package:mysen/features/shared/services/sql.dart';
import 'package:ntp/ntp.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Mainscreeniccontroller extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late PageController pageControllerCard;
  late final PageController pageController;
  RxInt currentpage = 0.obs;
  StateRequest? stateRequest;
  Color? colorBorder;

  RxBool isLoading = false.obs;

  Patient? patient;

  Patientsservices patientsservices = Patientsservices();
  Doctorservices doctorservices = Doctorservices();
  Requstreserveservices requstreserveservices = Requstreserveservices();

  final RxList<Doctor> _doctors = <Doctor>[].obs;
  RxList<Doctor> get doctors => _doctors;

  final RxList<Requestreservation> _requests = <Requestreservation>[].obs;
  RxList<Requestreservation> get requests => _requests;

  late final RealtimeChannel channel;
  DatabaseHelper sql = DatabaseHelper.instance;
  late InternetService internetService;
  StreamSubscription<bool>? subscription;
  final sharedPref = Get.find<SharedPrefService>();

  Color getColor(StateRequest state, BuildContext context) {
    switch (state) {
      case StateRequest.waiting:
        return Colors.orange;
      case StateRequest.completed:
        return context.primaryContainer;
      case StateRequest.reject:
        return const Color.fromARGB(255, 235, 25, 10);
      case StateRequest.none:
        return context.primarycolor;
      case StateRequest.accepted:
        return context.primaryContainer;
    }
  }

  double getWidthBorder(StateRequest state) {
    if (animationController.isAnimating) {
      return animationController.value;
    } else {
      if (state == StateRequest.none) {
        return animationController.lowerBound;
      } else {
        return animationController.upperBound;
      }
    }
  }

  void handleRequestState(StateRequest state) {
    if (state == StateRequest.waiting) {
      if (!animationController.isAnimating) {
        animationController.repeat(reverse: true);
      }
    } else {
      if (animationController.isAnimating) {
        animationController.stop();
      }
    }
  }

  Future<void> fetchDoctors() async {
    try {
      final sqldoctor = await sql.queryAll('doctors');
      if (!await internetService.checkNow()) {
        _doctors.assignAll(sqldoctor.map((e) => Doctor.fromMapSql(e)));
        return;
      }
      isLoading.value = true;
      final doctors = await doctorservices.fetchDoctors().timeout(
        const Duration(seconds: duration15),
      );
      _doctors.assignAll(doctors.map((doc) => Doctor.fromMap(doc)));
      for (var d in sqldoctor) {
        await sql.delete('doctors', d['id']);
      }
      for (var d in _doctors) {
        sql.insert('doctors', d.toMapSql());
      }
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);

      return;
    } on PostgrestException catch (_) {
      return;
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPatient() async {
    try {
      final sqlpatient = await sql.queryAll('patient');

      if (sqlpatient.isNotEmpty) {
        patient = Patient.fromMapsql(sqlpatient.first);
        return;
      }
      if (!await internetService.checkNow()) {
        return;
      }
      final userID = client.auth.currentUser;

      if (userID == null) {
        return;
      }
      isLoading.value = true;
      final fetchPatient = await patientsservices
          .fetchPatientsByUSerID(userID.id)
          .timeout(const Duration(seconds: duration15));

      if (fetchPatient == null) {
        return;
      }
      patient = Patient.fromMap(fetchPatient);
      await sql.insert('patient', patient!.toMapsql());
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (_) {
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getNotifications() async {
    await LocalNotificationService().cancelAll();

    final now = DateTime.now();
    final requestsCheck = _requests.where(
      (p0) =>
          p0.stateRequest == StateRequest.accepted ||
          p0.stateRequest == StateRequest.completed,
    );

    for (final r in requestsCheck) {
      if (r.reciveTime == null) continue;
      if (r.reciveTime!.isBefore(now)) continue; // تجاهل المنتهية

      // print('✅ تم جدولة الإشعارات موعدًا');

      final doctor = _doctors.firstWhereOrNull((d) => d.id == r.doctorID);

      await LocalNotificationService().scheduleAppointmentReminder(
        appointmentTime: r.reciveTime!,
        doctorName: doctor?.fullName ?? 'طبيبك',
      );
    }
  }

  void loadRequestFromSql() async {
    final r = await sql.queryAll('request');

    _requests.assignAll(r.map((e) => Requestreservation.fromMapsql(e)));
    update();
  }

  Future<void> fetchRequest() async {
    try {
      final requestsSql = await sql.queryAll('request');
      if (!await internetService.checkNow()) {
        return;
      }

      final request = await requstreserveservices.fetchRequstReserve().timeout(
        const Duration(seconds: duration15),
      );

      _requests.assignAll(request.map((e) => Requestreservation.fromMap(e)));

      for (var r in requestsSql) {
        await sql.delete('request', r['id']);
      }

      for (var r in _requests) {
        await sql.insert('request', r.toMapsql());
      }
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (_) {
    } catch (e) {
      ErrorHndel.handleError(ErrorType.error);
    } finally {
      loadRequestFromSql();
    }
  }

  Future<void> changeStateRequest() async {
    if (!await internetService.checkNow()) {
      return;
    }

    final now = await NTP.now();
    final nowDate = DateTime(now.year, now.month, now.day);
    final requestsCheck = _requests.where(
      (p0) =>
          p0.stateRequest == StateRequest.completed ||
          p0.stateRequest == StateRequest.accepted,
    );

    try {
      for (var r in requestsCheck) {
        if (r.reciveTime == null) continue;
        final receiveDate = DateTime(
          r.reciveTime!.year,
          r.reciveTime!.month,
          r.reciveTime!.day,
        );

        final isAfterDay = nowDate.isAfter(receiveDate);

        if (isAfterDay) {
          await requstreserveservices
              .updateRequest(r.copyWith(stateRequest: StateRequest.none))
              .timeout(const Duration(seconds: duration15));
          await sql.update(
            'request',
            r.copyWith(stateRequest: StateRequest.none).toMapsql(),
            r.id!,
          );
        }
      }
      loadRequestFromSql();
    } catch (_) {}
  }

  void addResqustReserv(String? doctorID) async {
    try {
      back();
      if (!await internetService.checkNow()) {
        ErrorHndel.handleError(ErrorType.internet);

        return;
      }

      final reservation = Requestreservation(
        doctorID: doctorID!,
        patientID: patient!.id!,
        patientName: patient?.fullName ?? 'no name',
        sendTime: await NTP.now(),
        stateRequest: StateRequest.waiting,
        phone: patient?.phone ?? '',
      );

      if (_requests.any((p0) => p0.stateRequest == StateRequest.waiting)) {
        MessageHandle.handleMessage(MessageType.requestWaiting);

        return;
      }
      final request = _requests.firstWhereOrNull(
        (element) => element.doctorID == doctorID,
      );

      if (request != null &&
          (request.stateRequest == StateRequest.completed ||
              request.stateRequest == StateRequest.accepted)) {
        MessageHandle.handleMessage(MessageType.requestComplete);

        return;
      }

      isLoading.value = true;
      await requstreserveservices
          .upsertRequstReserve(reservation)
          .timeout(const Duration(seconds: duration15));

      return;
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

  Future<void> updateRequestToNon(Requestreservation? requestReserv) async {
    try {
      back();

      isLoading.value = true;

      if (!await internetService.checkNow()) {
        ErrorHndel.handleError(ErrorType.internet);

        return;
      }

      if (requestReserv == null) {
        ErrorHndel.handleError(ErrorType.error);

        return;
      }

      await requstreserveservices
          .updateRequest(
            requestReserv.copyWith(stateRequest: StateRequest.none),
          )
          .timeout(const Duration(seconds: duration15));

      return;
    } on TimeoutException catch (_) {
      ErrorHndel.handleError(ErrorType.timeout);
    } on PostgrestException catch (_) {
      return;
    } catch (_) {
      return;
    } finally {
      isLoading.value = false;
    }
  }

  void back() {
    if (Get.isOverlaysOpen || Get.key.currentState?.canPop() == true) {
      Get.back(closeOverlays: true);
    }
  }

  void rout(String page) {
    Get.toNamed(page);
  }

  @override
  void onInit() {
    internetService = InternetService();
    subscription = internetService.onStatusChange.distinct().listen((
      hasInternet,
    ) {
      if (hasInternet) {
        changeStateRequest();
      } else {
        loadRequestFromSql();
      }
    });
    pageController = PageController();
    pageControllerCard = PageController();
    pageControllerCard.addListener(() {
      pageController.animateTo(
        pageControllerCard.offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    });
    pageController.addListener(() {
      if (pageController.page != null) {
        currentpage.value = pageController.page!.round();
      }
    });

    animationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 5,
      duration: const Duration(seconds: 1),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await fetchPatient();
      if (patient == null) {
        return;
      }

      fetchDoctors();
      await fetchRequest();
      getNotifications();
      changeStateRequest();
    });

    channel = Utils.setupRealtimeChannel(
      tableName: 'requestreservation',

      onInsert: (payload) async {
        final request = Requestreservation.fromMapPyload(
          map: payload.newRecord,
          patientName: patient?.fullName ?? '',
          phone: patient?.phone ?? '',
        );
        await sql.insert('request', request.toMapsql());
        loadRequestFromSql();
      },

      onUpdate: (payload) async {
        final request = Requestreservation.fromMapPyload(
          map: payload.newRecord,
          patientName: patient?.fullName ?? '',
          phone: patient?.phone ?? '',
        );
        await sql.update(
          'request',
          request.toMapsql(),

          payload.newRecord['id'],
        );

        loadRequestFromSql();
      },
    );

    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    pageControllerCard.dispose();
    animationController.stop();
    animationController.dispose();
    client.removeChannel(channel);
    internetService.dispose();
    subscription?.cancel();
  }
}
