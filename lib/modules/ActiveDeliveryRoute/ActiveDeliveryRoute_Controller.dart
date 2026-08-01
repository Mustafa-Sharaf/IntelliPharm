import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../Widgets/AppSnackBar.dart';
import '../../helper/mapHelper/dart/MapDrawerHelper.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../../services/ApiService.dart';
import '../Tracking/LiveLocationTracker.dart';
import 'ActiveDeliveryRoute_Model.dart';

class ActiveDeliveryRouteController extends GetxController {
  final routeMapController = Get.find<MapHelperController>(tag: "route");
  // 🟢 استدعاء الـ Location Tracker
  LiveLocationTracker get locationTracker => Get.find<LiveLocationTracker>();

  var isLoading = false.obs;
  var plan = Rxn<DeliveryPlan>();
  var activeVisitIndex = 0.obs;


  Future<bool> initiateDeliveryPlan() async {
    try {
      isLoading.value = true;
      final response = await ApiService.post(
        "/planner/v1/plans/initiate-from-deliveries",
        data: {
          "current_longitude": routeMapController.longitude.value,
          "current_latitude": routeMapController.latitude.value,
          "rep_id": 1,
          "reason": "initiated",
          "reason_details": null,
          "profile": "balanced",
          "travel_mode": "driving"
        },
      );

      if (response.data['isSuccess']) {
        final planResult = DeliveryPlan.fromJson(response.data['data']);
        plan.value = planResult;

        await MapDrawerHelper.drawFullRoute(
          routeMapController: routeMapController,
          plan: plan.value!.toPlanResponse(),
        );

        routeMapController.update();
        plan.refresh();
        locationTracker.startTracking();

        return true; 
      } else {
        AppSnackBar.error("فشل في تهيئة مسار التوصيل.");
        return false;
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        print("SERVER ERROR: ${e.response?.data}");
      } else {
        print("ERROR: $e");
      }
      AppSnackBar.error("حدث خطأ غير متوقع أثناء إعداد المسار.");
      return false;
    } finally {
      isLoading.value = false;
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
      regionName: currentPlan.regionName
    );
    int nextActiveIndex = updatedVisits.indexWhere((v) => v.status != 'completed' && v.visited != 1);
    if (nextActiveIndex != -1) {
      activeVisitIndex.value = nextActiveIndex;
    } else {
      activeVisitIndex.value = updatedVisits.length;
    }
    plan.refresh();
  }

  @override
  void onClose() {
    // 🛑 إيقاف التتبع عند إغلاق صفحة الموزع
    locationTracker.stopTracking();
    super.onClose();
  }
}