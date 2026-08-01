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
    // 🟢 بدء التتبع فور تحضير الـ Binding
    locationTracker.startTracking();
  }

  Future<void> refreshTrackingData() async {
    isLoading.value = true;
    await planYourRouteController.fetchCurrentPlan();
    isLoading.value = false;
  }

  Future<void> handleRePlan() async {
    // التأكد أولاً من وجود Plan حقيقية
    if (plan == null) {
      AppSnackBar.error("No active route to re-plan");
      return;
    }

    Get.dialog(
      RePlanDialog(
        onSubmit: (reason, reasonDetails) async {
          try {
            isLoading.value = true;

            // 1. جلب الموقع المباشر الحالي
            final mapController = Get.find<MapHelperController>(tag: "route");
            await mapController.moveToCurrentLocation();

            // 2. إرسال الطلب مع تمرير plan.id
            final responseData = await PlannerService.rePlanRoute(
              planId: plan!.id, // 👈 تمرير رقم الخطّة الحالية هنا
              latitude: mapController.latitude.value,
              longitude: mapController.longitude.value,
              reason: reason,
              reasonDetails: reasonDetails,
            );

            if (responseData != null && responseData['isSuccess'] == true) {
              // 3. تحديث خطة المسار في الـ PlanYourRouteController بالبيانات الجديدة
              final updatedPlan = PlanResponse.fromJson(responseData['data']);
              planYourRouteController.plan.value = updatedPlan;

              // 4. إعادة رسم الخريطة بالمسار المحدث
              await MapDrawerHelper.drawFullRoute(
                routeMapController: mapController,
                plan: updatedPlan,
              );

              AppSnackBar.success("Next leg optimized successfully");
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


  @override
  void onClose() {
    // 1. إيقاف البث والمؤقتات
    locationTracker.stopTracking();
    super.onClose();
  }
}