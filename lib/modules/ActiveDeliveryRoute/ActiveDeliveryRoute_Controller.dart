import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/AppSnackBar.dart';
import '../../helper/mapHelper/dart/MapDrawerHelper.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../../services/ApiService.dart';
import '../../services/ServiceApi/PlannerService.dart';
import '../../services/ServiceApi/RouteStepService.dart';
import '../PlanYourRoute/ReverbService.dart';
import '../RePlan/RePlanDialog.dart';
import '../Tracking/LiveLocationTracker.dart';
import 'ActiveDeliveryRoute_Model.dart';

class ActiveDeliveryRouteController extends GetxController {
  final routeMapController = Get.find<MapHelperController>(
    tag: "routeDelivery",
  );
  LiveLocationTracker get locationTracker => Get.find<LiveLocationTracker>();
  final currentMapController = Get.find<MapHelperController>(
    tag: "routeDelivery",
  );

  var isLoading = false.obs;
  var plan = Rxn<DeliveryPlan>();
  var activeVisitIndex = 0.obs;
  var showOnlyNextLeg = false.obs;

  Timer? _pollingTimer;
  String? _currentRequestId;
  String? _currentChannel;

  DeliveryVisit? get nextVisit {
    if (plan.value == null || plan.value!.visits.isEmpty) return null;
    try {
      return plan.value!.visits.firstWhere(
        (v) => v.status != 'completed' && v.visited != 1,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    ever(showOnlyNextLeg, (_) {
      redrawRouteOnMap();
    });
    fetchTodayDeliveryPlan();
  }

  /// دالة التبديل بين المسار الكامل والوجهة التالية
  void toggleRouteMode() {
    showOnlyNextLeg.value = !showOnlyNextLeg.value;
  }

  /// إعادة رسم المسار على الخريطة حسب النمط المختار
  Future<void> redrawRouteOnMap() async {
    final currentPlan = plan.value;
    if (currentPlan == null) return;

    routeMapController.markers.clear();
    routeMapController.polyLines.clear();

    if (showOnlyNextLeg.value) {
      final targetVisit = nextVisit;
      if (targetVisit != null) {
        int nextVisitIndex = currentPlan.visits.indexOf(targetVisit);

        String? legGeometry;
        double destLat = 0.0;
        double destLng = 0.0;

        if (nextVisitIndex != -1 && nextVisitIndex < currentPlan.paths.length) {
          legGeometry = currentPlan.paths[nextVisitIndex].geometry;

          if (legGeometry.isNotEmpty) {
            final decodedPoints = MapDrawerHelper.decodePolyline(legGeometry);
            if (decodedPoints.isNotEmpty) {
              destLat = decodedPoints.last.latitude;
              destLng = decodedPoints.last.longitude;
            }
          }
        }

        await MapDrawerHelper.drawSingleDirectPath(
          mapController: routeMapController,
          destLat: destLat,
          destLng: destLng,
          destinationName: targetVisit.pharmacyName,
          geometry: legGeometry,
        );
      }
    } else {
      await MapDrawerHelper.drawFullRoute(
        routeMapController: routeMapController,
        plan: currentPlan.toPlanResponse(),
      );
    }

    routeMapController.markers.refresh();
    routeMapController.polyLines.refresh();
  }

  Future<bool> initiateDeliveryPlan() async {
    final Completer<bool> planCompleter = Completer<bool>();

    try {
      isLoading.value = true;

      await routeMapController.moveToCurrentLocation();

      final response = await ApiService.post(
        "/planner/v1/plans/initiate-from-deliveries",
        data: {
          "current_longitude": routeMapController.longitude.value,
          "current_latitude": routeMapController.latitude.value,
          "rep_id": null,
          "reason": "initiated",
          "reason_details": null,
          "profile": "balanced",
          "travel_mode": "driving",
        },
      );

      if (response.data != null && response.data['isSuccess'] == true) {
        final queueData = response.data['data'];

        // 1. التحقق الصارم: هل الخطة جاهزة ومكتملة بحق؟ (ليست null وليست قائمة زيارات فارغة)

        if (queueData != null &&
            queueData['plan'] != null &&
            queueData['plan'] is Map &&
            queueData['plan']['visits'] != null &&
            (queueData['plan']['visits'] as List).isNotEmpty) {
          await _handleDeliveryPlanSuccess(queueData['plan']);
          isLoading.value = false;
          return true;
        }
        // 2. البيانات غير جاهزة (Status 202 - Queued) -> يجب الانتظار للسوكيت أو Polling
        _currentRequestId = queueData['request_id'];
        _currentChannel = queueData['channel'];
        final readyEvent = queueData['ready_event'] ?? 'plan.ready';
        final failedEvent = queueData['failed_event'] ?? 'plan.failed';
        Get.snackbar(
          "Planning is underway".tr,
          "We are currently calculating the optimal delivery route, please wait...".tr,
          backgroundColor: Colors.blue.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        final reverbService = Get.find<ReverbService>();
        // الاشتراك في قناة السوكيت
        await reverbService.subscribe(
          channel: _currentChannel!,
          onEvent: (event, payload) async {
            final incomingId = payload['request_id'] ?? payload['id'];
            if (incomingId == _currentRequestId || _currentRequestId == null) {
              if (event == readyEvent) {
                _stopPlanListening();
                // استخراج الخطة من payload السوكيت
                final planPayload = payload['plan'] ?? payload;
                await _handleDeliveryPlanSuccess(planPayload);
                isLoading.value = false;
                if (!planCompleter.isCompleted) planCompleter.complete(true);
              } else if (event == failedEvent) {
                _stopPlanListening();
                isLoading.value = false;
                AppSnackBar.error("Failure to configure the connection path.".tr);
                if (!planCompleter.isCompleted) planCompleter.complete(false);
              }
            }
          },
        );
        // تشغيل الـ Polling كخيار احتياطي في حال تأخر السوكيت
        _startPollingFallback(_currentRequestId!, planCompleter);
        // لن تنتقل الصفحة حتى يكتمل الـ Completer بواسطة السوكيت أو الـ Polling
        return await planCompleter.future;
      } else {
        isLoading.value = false;
        AppSnackBar.error("Failed to initialize the connection path.".tr);
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      AppSnackBar.error("An unexpected error occurred during path setup.".tr);
      if (!planCompleter.isCompleted) planCompleter.complete(false);
      return false;
    }
  }

  Future<void> _handleDeliveryPlanSuccess(dynamic planJson) async {
    try {
      isLoading.value = false;

      if (planJson == null) {
        print("❌ Error: planJson is null");
        return;
      }
      Map<String, dynamic> actualPlanData;
      if (planJson is Map<String, dynamic>) {
        // إذا كانت الخريطة تحتوي على مفتاح plan نقوم باستخراجه، وإلا نستخدم الخريطة نفسها
        if (planJson.containsKey('plan') && planJson['plan'] != null) {
          actualPlanData = Map<String, dynamic>.from(planJson['plan']);
        } else {
          actualPlanData = Map<String, dynamic>.from(planJson);
        }
      } else {
        print("Error: planJson is not a Map");
        return;
      }
      // إنشاء الـ Model من البيانات النظيفة
      final planResult = DeliveryPlan.fromJson(actualPlanData);
      plan.value = planResult;
      // حماية استدعاء الخريطة لضمان عدم حدوث Crash إذا لم تكن الواجهة جاهزة بعد
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          await redrawRouteOnMap();
        } catch (e) {
          print(" Map Redraw Warning: $e");
        }
      });
      if (planResult.visits.isNotEmpty) {
        int nextActiveIndex = planResult.visits.indexWhere(
          (v) => v.status != 'completed' && v.visited != 1,
        );
        activeVisitIndex.value = (nextActiveIndex != -1) ? nextActiveIndex : 0;
      } else {
        activeVisitIndex.value = 0;
      }

      plan.refresh();

      //  بدء التتبع
      try {
        locationTracker.startTracking();
      } catch (e) {
        print(" Location Tracker Warning: $e");
      }

      AppSnackBar.success("The delivery route was successfully set up".tr);
    } catch (e, stackTrace) {
      print("❌ Error parsing delivery plan: $e");
      print(stackTrace);
      AppSnackBar.error("Failed to parse delivery plan data".tr);
    }
  }

  void _startPollingFallback(String requestId, Completer<bool> completer) {
    _pollingTimer?.cancel();
    int attempts = 0;
    const maxAttempts = 15;
    _pollingTimer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      attempts++;
      if (attempts > maxAttempts) {
        _stopPlanListening();
        isLoading.value = false;
        AppSnackBar.error("The server took a long time to calculate the path. Please try again later.".tr);
        if (!completer.isCompleted) completer.complete(false);
        return;
      }

      try {
        final res = await PlannerService.getGenerationStatus(requestId);
        if (res != null && res['isSuccess'] == true) {
          final data = res['data'];
          final status = data['status'];
          if (status == 'completed' || status == 'success') {
            _stopPlanListening();
            // التأكد من أخذ كائن 'plan' تحديداً إذا كان موجوداً
            final planData = (data != null && data['plan'] != null)
                ? data['plan']
                : data;
            await _handleDeliveryPlanSuccess(planData);
            if (!completer.isCompleted) completer.complete(true);
          } else if (status == 'failed') {
            _stopPlanListening();
            isLoading.value = false;
            AppSnackBar.error("Path setup failed".tr);
            if (!completer.isCompleted) completer.complete(false);
          }
        }
      } catch (e) {
        print("Delivery Polling Error: $e");
      }
    });
  }

  void _stopPlanListening() {
    _pollingTimer?.cancel();
    if (_currentChannel != null) {
      Get.find<ReverbService>().unsubscribe(_currentChannel!);
    }
  }

  void markVisitAsCompleted(int visitId) {
    if (plan.value == null) return;
    final currentPlan = plan.value!;

    final updatedVisits = currentPlan.visits.map((visit) {
      if (visit.id == visitId) {
        // استخدام copyWith يضمن الحفاظ على deliveryId الحقيقي
        return visit.copyWith(status: "completed", visited: 1);
      }
      return visit;
    }).toList();

    plan.value = currentPlan.copyWith(visits: updatedVisits);

    int nextActiveIndex = updatedVisits.indexWhere(
      (v) => v.status != 'completed' && v.visited != 1,
    );
    activeVisitIndex.value = (nextActiveIndex != -1)
        ? nextActiveIndex
        : updatedVisits.length;

    redrawRouteOnMap();
    plan.refresh();
  }

  /// تحديث الخطة فوراً من بيانات الـ Response القادمة من الـ API
  Future<void> updatePlanFromStatusResponse(
    Map<String, dynamic> planJson,
  ) async {
    try {
      final updatedDeliveryPlan = DeliveryPlan.fromJson(planJson);
      plan.value = updatedDeliveryPlan;

      await redrawRouteOnMap();

      int nextActiveIndex = updatedDeliveryPlan.visits.indexWhere(
        (v) => v.status != 'completed' && v.visited != 1,
      );
      activeVisitIndex.value = (nextActiveIndex != -1)
          ? nextActiveIndex
          : updatedDeliveryPlan.visits.length;

      routeMapController.update();
      plan.refresh();
    } catch (e) {
      print(" Error updating delivery plan from status response: $e");
    }
  }

  Future<void> handleRePlan() async {
    if (plan.value == null) {
      AppSnackBar.error("NoActiveRouteToRePlan".tr);
      return;
    }

    Get.dialog(
      RePlanDialog(
        onSubmit: (reason, reasonDetails) async {
          Get.back();
          try {
            isLoading.value = true;

            await routeMapController.moveToCurrentLocation();

            final responseData = await PlannerService.rePlanRoute(
              planId: plan.value!.id,
              latitude: routeMapController.latitude.value,
              longitude: routeMapController.longitude.value,
              reason: reason,
              reasonDetails: reasonDetails,
            );

            if (responseData != null && responseData['isSuccess'] == true) {
              final planData = responseData['data'];

              if (planData != null &&
                  (planData['visits'] != null || planData['stops'] != null)) {
                await updatePlanFromStatusResponse(planData);
                AppSnackBar.success("NextLegOptimizedSuccessfully".tr);
              }
            } else {
              AppSnackBar.error("FailedToRePlanRoute".tr);
            }
          } catch (e) {
            print("❌ RePlan Error: $e");
            AppSnackBar.error("ErrorOccurredRePlanning".tr);
          } finally {
            isLoading.value = false;
          }
        },
      ),
    );
  }

  Future<void> updateVisitStatus({
    required int visitId,
    required String status,
    required String cause,
    String? notes,
  }) async {
    try {
      isLoading.value = true;

      final response = await RouteStepService.updateVisitStatus(
        visitId: visitId,
        status: status,
        cause: cause,
        notes: notes,
        longitude: currentMapController.longitude.value,
        latitude: currentMapController.latitude.value,
      );

      if (response != null &&
          (response['isSuccess'] == true || response['statusCode'] == 200)) {
        Get.back();

        if (response['data'] != null) {
          await updatePlanFromStatusResponse(response['data']);
        }

        AppSnackBar.success("VisitStatusUpdatedSuccessfully".tr);
      } else {
        AppSnackBar.error("FailedToUpdateStatus".tr);
      }
    } catch (e) {
      print(" Update Status Error: $e");
      AppSnackBar.error("ErrorOccurredWhileUpdating".tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTodayDeliveryPlan() async {
    try {
      isLoading.value = true;
      final responseData = await PlannerService.getMyDeliveryToday();

      if (responseData != null &&
          responseData['isSuccess'] == true &&
          responseData['data'] != null) {
        await updatePlanFromStatusResponse(responseData['data']);
      }
    } catch (e) {
      print("Fetch Today Plan Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _stopPlanListening();
    locationTracker.stopTracking();
    super.onClose();
  }
}
