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
  PlanYourRouteController get planYourRouteController =>
      Get.find<PlanYourRouteController>();
  LiveLocationTracker get locationTracker => Get.find<LiveLocationTracker>();

  var isLoading = false.obs;
  var selectedRegion = ''.obs;
  var showOnlyNextLeg = false.obs;
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
    ever(showOnlyNextLeg, (_) {
      redrawRouteOnMap();
    });

    fetchMyTodayPlan();
  }

  void toggleRouteMode() {
    showOnlyNextLeg.value = !showOnlyNextLeg.value;
  }

  Future<void> refreshTrackingData() async {
    isLoading.value = true;
    await planYourRouteController.fetchCurrentPlan();
    await redrawRouteOnMap();
    isLoading.value = false;
  }

  Future<void> redrawRouteOnMap() async {
    final currentPlan = plan;
    if (currentPlan == null) return;

    final mapController = Get.find<MapHelperController>(tag: "route");

    mapController.markers.clear();
    mapController.polyLines.clear();

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
          mapController: mapController,
          destLat: destLat,
          destLng: destLng,
          destinationName: targetVisit.name,
          geometry: legGeometry,
        );
      }
    } else {
      await MapDrawerHelper.drawFullRoute(
        routeMapController: mapController,

        plan: currentPlan,
      );
    }

    mapController.markers.refresh();
    mapController.polyLines.refresh();
  }

  Future<void> handleRePlan() async {
    final currentPlan = plan;
    if (currentPlan == null) {
      AppSnackBar.error("No active route to re-plan".tr);
      return;
    }

    Get.dialog(
      RePlanDialog(
        onSubmit: (reason, reasonDetails) async {
          try {
            isLoading.value = true;
            final mapController = Get.find<MapHelperController>(tag: "route");
            await mapController.moveToCurrentLocation();
            final responseData = await PlannerService.rePlanRoute(
              planId: currentPlan.id,
              latitude: mapController.latitude.value,
              longitude: mapController.longitude.value,
              reason: reason,
              reasonDetails: reasonDetails,
            );
            print("🔍 RePlan API Response: $responseData");
            if (responseData != null && responseData['isSuccess'] == true) {
              final planData = responseData['data'];
              if (planData != null &&
                  (planData['visits'] != null || planData['stops'] != null)) {
                final updatedPlan = PlanResponse.fromJson(planData);
                planYourRouteController.plan.value = updatedPlan;
                await redrawRouteOnMap();
                AppSnackBar.success("Next leg optimized successfully".tr);
              } else if (planData != null && planData['request_id'] != null) {
                print(
                  "RePlan queued with Request ID: ${planData['request_id']}",
                );
                AppSnackBar.success("Re-planning queued, optimizing route...".tr);
              } else {
                print("Response data structure mismatch: $planData");
              }
            } else {
              AppSnackBar.error("Failed to re-plan route".tr);
            }
          } catch (e, stackTrace) {
            // 2. طباعة الاستثناء والـ StackTrace بالتفصيل عند حدوث Exception
            print("Exception in handleRePlan: $e");
            print("StackTrace: $stackTrace");
            AppSnackBar.error("An error occurred while re-planning the route".tr);
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
        final updatedPlan = PlanResponse.fromJson(responseData['data']);
        planYourRouteController.plan.value = updatedPlan;
        final mapController = Get.find<MapHelperController>(tag: "route");
        mapController.markers.clear();
        mapController.polyLines.clear();
        await redrawRouteOnMap();
        await mapController.moveToCurrentLocation();
      }
    } catch (e) {
      print("Error updating today's plan & map: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updatePlanFromStatusResponse(Map<String, dynamic> planJson) {
    try {
      // 1. تحويل الـ JSON إلى كائن PlanResponse
      final updatedPlan = PlanResponse.fromJson(planJson);
      // 2. تحديث الخطة الحالية في PlanYourRouteController
      planYourRouteController.plan.value = updatedPlan;
      // 3. إعادة رسم المسار والنقاط على الخريطة
      redrawRouteOnMap();
    } catch (e) {
      print("Error updating plan from status response: $e");
    }
  }

  @override
  void onClose() {
    locationTracker.stopTracking();

    super.onClose();
  }
}
