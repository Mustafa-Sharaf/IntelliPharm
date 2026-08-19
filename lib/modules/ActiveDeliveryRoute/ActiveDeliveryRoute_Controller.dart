
import 'dart:async';
import 'package:dio/dio.dart';
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
  final routeMapController = Get.find<MapHelperController>(tag: "routeDelivery");
  LiveLocationTracker get locationTracker => Get.find<LiveLocationTracker>();

  var isLoading = false.obs;
  var plan = Rxn<DeliveryPlan>();
  var activeVisitIndex = 0.obs;

  Timer? _pollingTimer;
  String? _currentRequestId;
  String? _currentChannel;

  /// 🟢 إنشاء/تهيئة خطة التوصيل عبر WebSocket مع انتظار النتيجة الكاملة قبل الانتقال
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
          "travel_mode": "driving"
        },
      );

      if (response.data != null && response.data['isSuccess'] == true) {
        final queueData = response.data['data'];

        // 1. إذا رجعت الخطة مباشرة (Status 200)
        if (queueData != null && queueData['visits'] != null) {
          await _handleDeliveryPlanSuccess(queueData);
          return true;
        }

        // 2. إذا دخلت في Queue (Status 202)
        _currentRequestId = queueData['request_id'];
        _currentChannel = queueData['channel'];

        final readyEvent = queueData['ready_event'] ?? 'plan.ready';
        final failedEvent = queueData['failed_event'] ?? 'plan.failed';

        print("📡 Subscribing to Delivery Channel: $_currentChannel");

        Get.snackbar(
          "جاري التخطيط",
          "جاري حساب مسار التوصيل الأمثل، يرجى الانتظار...",
          backgroundColor: Colors.blue.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );

        final reverbService = Get.find<ReverbService>();
        await reverbService.subscribe(
          channel: _currentChannel!,
          onEvent: (event, payload) async {
            print("🔔 Delivery Event [$event]: $payload");

            final incomingId = payload['request_id'] ?? payload['id'];

            if (incomingId == _currentRequestId) {
              if (event == readyEvent) {
                _stopPlanListening();
                await _handleDeliveryPlanSuccess(payload['plan'] ?? payload);
                if (!planCompleter.isCompleted) planCompleter.complete(true);
              } else if (event == failedEvent) {
                _stopPlanListening();
                isLoading.value = false;
                AppSnackBar.error(
                  payload['message'] ?? payload['error'] ?? "فشل إعداد مسار التوصيل.",
                );
                if (!planCompleter.isCompleted) planCompleter.complete(false);
              }
            }
          },
        );

        _startPollingFallback(_currentRequestId!, planCompleter);

        // 🟢 ننتظر النتيجة الحقيقية من الـ Socket أو الـ Polling قبل الإرجاع للـ UI
        return await planCompleter.future;
      } else {
        isLoading.value = false;
        AppSnackBar.error("فشل في تهيئة مسار التوصيل.");
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      if (e is DioException && e.response != null) {
        print("SERVER ERROR: ${e.response?.data}");
      } else {
        print("ERROR: $e");
      }
      AppSnackBar.error("حدث خطأ غير متوقع أثناء إعداد المسار.");
      return false;
    }
  }

  /// 🟢 معالجة النجاح وإعادة الرسم فور استلام البيانات
  Future<void> _handleDeliveryPlanSuccess(dynamic planJson) async {
    isLoading.value = false;
    final planResult = DeliveryPlan.fromJson(planJson);
    plan.value = planResult;

    await MapDrawerHelper.drawFullRoute(
      routeMapController: routeMapController,
      plan: plan.value!.toPlanResponse(),
    );

    int nextActiveIndex = planResult.visits.indexWhere(
          (v) => v.status != 'completed' && v.visited != 1,
    );
    activeVisitIndex.value = (nextActiveIndex != -1) ? nextActiveIndex : 0;

    routeMapController.update();
    plan.refresh();
    locationTracker.startTracking();

    AppSnackBar.success("تم إعداد مسار التوصيل بنجاح");
  }

  /// 🟢 المؤقت الاحتياطي (Polling)
  void _startPollingFallback(String requestId, Completer<bool> completer) {
    _pollingTimer?.cancel();
    int attempts = 0;
    const maxAttempts = 15;

    _pollingTimer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      attempts++;

      if (attempts > maxAttempts) {
        _stopPlanListening();
        isLoading.value = false;
        AppSnackBar.error("استغرق السيرفر وقتاً طويلاً في حساب المسار. يرجى المحاولة لاحقاً.");
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
            final planData = data['plan'] ?? data;
            await _handleDeliveryPlanSuccess(planData);
            if (!completer.isCompleted) completer.complete(true);
          } else if (status == 'failed') {
            _stopPlanListening();
            isLoading.value = false;
            AppSnackBar.error(data['error_message'] ?? "فشل إعداد المسار");
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
        return DeliveryVisit(
          id: visit.id,
          deliveryId: visit.deliveryId,
          pharmacyName: visit.pharmacyName,
          orderId: visit.orderId,
          orderItemCount: visit.orderItemCount,
          status: "completed",
          visitOrder: visit.visitOrder,
          planId: visit.planId,
          visited: 1,
        );
      }
      return visit;
    }).toList();

    plan.value = DeliveryPlan(
      id: currentPlan.id,
      totalDistanceKm: currentPlan.totalDistanceKm,
      totalDurationSec: currentPlan.totalDurationSec,
      visits: updatedVisits,
      paths: currentPlan.paths,
      regionName: currentPlan.regionName,
    );

    int nextActiveIndex = updatedVisits.indexWhere((v) => v.status != 'completed' && v.visited != 1);
    activeVisitIndex.value = (nextActiveIndex != -1) ? nextActiveIndex : updatedVisits.length;
    plan.refresh();
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

              if (planData != null && (planData['visits'] != null || planData['stops'] != null)) {
                final updatedDeliveryPlan = DeliveryPlan.fromJson(planData);
                plan.value = updatedDeliveryPlan;

                await MapDrawerHelper.drawFullRoute(
                  routeMapController: routeMapController,
                  plan: plan.value!.toPlanResponse(),
                );

                int nextActiveIndex = updatedDeliveryPlan.visits.indexWhere(
                      (v) => v.status != 'completed' && v.visited != 1,
                );
                activeVisitIndex.value = (nextActiveIndex != -1) ? nextActiveIndex : 0;

                routeMapController.update();
                plan.refresh();

                AppSnackBar.success("NextLegOptimizedSuccessfully".tr);
              }
            } else {
              final msg = responseData?['message'] ?? "FailedToRePlanRoute".tr;
              AppSnackBar.error(msg);
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
      );

      if (response != null && response['isSuccess'] == true) {
        Get.back();
        await fetchTodayDeliveryPlan();

        if (plan.value != null) {
          final updatedVisits = plan.value!.visits.map((visit) {
            if (visit.id == visitId) {
              return visit.copyWith(status: status);
            }
            return visit;
          }).toList();

          plan.value = plan.value!.copyWith(visits: updatedVisits);

          int nextActiveIndex = updatedVisits.indexWhere(
                (v) => v.status != 'completed' && v.visited != 1,
          );
          activeVisitIndex.value = (nextActiveIndex != -1) ? nextActiveIndex : updatedVisits.length;

          plan.refresh();
        }

        AppSnackBar.success("VisitStatusUpdatedSuccessfully".tr);
      } else {
        final msg = response?['message'] ?? "FailedToUpdateStatus".tr;
        AppSnackBar.error(msg);
      }
    } catch (e) {
      print("❌ Update Status Error: $e");
      AppSnackBar.error("ErrorOccurredWhileUpdating".tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTodayDeliveryPlan() async {
    try {
      isLoading.value = true;
      final responseData = await PlannerService.getMyDeliveryToday();

      if (responseData != null && responseData['isSuccess'] == true && responseData['data'] != null) {
        final updatedPlan = DeliveryPlan.fromJson(responseData['data']);
        plan.value = updatedPlan;

        await MapDrawerHelper.drawFullRoute(
          routeMapController: routeMapController,
          plan: plan.value!.toPlanResponse(),
        );

        int nextActiveIndex = updatedPlan.visits.indexWhere(
              (v) => v.status != 'completed' && v.visited != 1,
        );
        activeVisitIndex.value = (nextActiveIndex != -1) ? nextActiveIndex : updatedPlan.visits.length;

        routeMapController.update();
        plan.refresh();
      }
    } catch (e) {
      print("❌ Fetch Today Plan Error: $e");
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