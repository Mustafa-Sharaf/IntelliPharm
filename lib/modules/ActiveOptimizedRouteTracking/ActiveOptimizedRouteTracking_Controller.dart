import 'dart:convert';

import 'package:get/get.dart';
import '../../Widgets/AppSnackBar.dart';
import '../../helper/mapHelper/dart/MapDrawerHelper.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../../modules/ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Model.dart';
import '../../services/ServiceApi/PlannerService.dart';
import '../PlanYourRoute/PlanYourRoute_Controller.dart';
import '../RePlan/RePlanDialog.dart';
import '../Tracking/LiveLocationTracker.dart';

class ActiveOptimizedRouteTrackingController extends GetxController {

  PlanYourRouteController get planYourRouteController => Get.find<PlanYourRouteController>();
  LiveLocationTracker get locationTracker => Get.find<LiveLocationTracker>();

  var isLoading = false.obs;
  var selectedRegion = ''.obs;

  PlanResponse? get plan => planYourRouteController.plan.value;

  PlanVisit? get nextVisit {
    if (plan == null || plan!.visits.isEmpty) {
      return null;
    }
    try {
      return plan!.visits.firstWhere((v) => !v.visited);
    } catch (_) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    locationTracker.startTracking();
    fetchMyTodayPlan();
  }

  Future<void> refreshTrackingData() async {
    isLoading.value = true;
    await planYourRouteController.fetchCurrentPlan();
    isLoading.value = false;
  }

  Future<void> handleRePlan() async {
    // 🟢 1. التأكد أولاً من وجود Plan حقيقية
    final currentPlan = plan;
    if (currentPlan == null) {
      AppSnackBar.error("No active route to re-plan");
      return;
    }

    Get.dialog(
      RePlanDialog(
        onSubmit: (reason, reasonDetails) async {
          // 🟢 2. إغلاق الـ Dialog مباشرة بعد الضغط على التأكيد
          //Get.back();

          try {
            isLoading.value = true;

            // 🟢 3. جلب الموقع المباشر الحالي بأمان
            final mapController = Get.find<MapHelperController>(tag: "route");
            await mapController.moveToCurrentLocation();

            // 🟢 4. إعداد الـ Payload للطباعة قبل الإرسال (للتحقق)
            final requestBody = {
              "current_latitude": mapController.latitude.value,
              "current_longitude": mapController.longitude.value,
              "reason": reason,
              "reason_details": reasonDetails,
            };

            print("========= 🚀 SENDING REPLAN REQUEST =========");
            print("📍 PLAN ID: ${currentPlan.id}");
            print("📦 BODY: ${jsonEncode(requestBody)}");
            print("=============================================");

            // 🟢 5. إرسال الطلب مع تمرير planId الصحيح
            final responseData = await PlannerService.rePlanRoute(
              planId: currentPlan.id,
              latitude: mapController.latitude.value,
              longitude: mapController.longitude.value,
              reason: reason,
              reasonDetails: reasonDetails,
            );

            print("=================== 📥 REPLAN RESPONSE 📥 ===================");
            print(const JsonEncoder.withIndent('  ').convert(responseData));
            print("=============================================================");

            if (responseData != null && responseData['isSuccess'] == true) {
              // 🟢 6. إذا كانت الاستجابة تحتوي على خطة محدثة مباشرة (200 OK)
              final planData = responseData['data'];

            /*  if (planData != null && planData['stops'] != null) {
                final updatedPlan = PlanResponse.fromJson(planData);

                // 🟢 التحديث في الكنترولر الأساسي مباشرة
                planYourRouteController.plan.value = updatedPlan;

                // إعادة رسم الخريطة بالمسار المحدث
                await MapDrawerHelper.drawFullRoute(
                  routeMapController: mapController,
                  plan: updatedPlan,
                );

                AppSnackBar.success("Next leg optimized successfully");
              }*/
              if (planData != null && (planData['visits'] != null || planData['stops'] != null)) {
                final updatedPlan = PlanResponse.fromJson(planData);

                // 🟢 التحديث في الكنترولر الأساسي مباشرة
                planYourRouteController.plan.value = updatedPlan;

                // إعادة رسم الخريطة بالمسار المحدث
                await MapDrawerHelper.drawFullRoute(
                  routeMapController: mapController,
                  plan: updatedPlan,
                );

                AppSnackBar.success("Next leg optimized successfully");
              }else if (planData != null && planData['request_id'] != null) {
                // 🟢 7. في حال كان الباك إند يستخدم Queue مع Reverb لإعادة التخطيط
                AppSnackBar.success("Re-planning queued, optimizing route...");
              }
            } else {
              final msg = responseData?['message'] ?? "Failed to re-plan route";
              AppSnackBar.error(msg);
            }
          } catch (e) {
            print("❌ RePlan Error: $e");
            AppSnackBar.error("An error occurred while re-planning the route");
          } finally {
            isLoading.value = false;
          }
        },
      ),
    );
  }

  Future<void> fetchMyTodayPlan() async {
    try {
      isLoading.value = true;
      final responseData = await PlannerService.getMyTodayPlan();

      if (responseData != null && responseData['isSuccess'] == true) {
        // 1. تحويل البيانات وتحديث الـ Controller
        final updatedPlan = PlanResponse.fromJson(responseData['data']);
        planYourRouteController.plan.value = updatedPlan;

        // 2. الحصول على كائن الخريطة
        final mapController = Get.find<MapHelperController>(tag: "route");

        // 🧹 3. مسح المسارات والعلامات (Markers) القديمة من الخريطة أولاً
        mapController.markers.clear();
        mapController.polyLines.clear();

        // 🎨 4. إعادة رسم المسار والنقاط المتبقية
        await MapDrawerHelper.drawFullRoute(
          routeMapController: mapController,
          plan: updatedPlan,
        );

        // 🔍 5. نقل الكاميرا لتركّز على المسار الجديد / الموقع الحالي
        await mapController.moveToCurrentLocation();
      }
    } catch (e) {
      print("❌ Error updating today's plan & map: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // 1. إيقاف البث والمؤقتات
    locationTracker.stopTracking();
    super.onClose();
  }
}