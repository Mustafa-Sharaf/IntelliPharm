import 'package:get/get.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../../modules/ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Controller.dart';
import '../../services/ServiceApi/RouteStepService.dart';
import '../../widgets/AppSnackBar.dart';

class RouteStepController extends GetxController {
  var isStartingVisit = false.obs;
  var isUpdatingStatus = false.obs;

  final currentMapController = Get.find<MapHelperController>(tag: "route");

  /// Start of visit
  Future<void> startVisit(int visitId) async {
    try {
      isStartingVisit.value = true;

      final res = await RouteStepService.startVisit(visitId);

      if (res != null && (res['isSuccess'] == true || res['statusCode'] == 200)) {
        AppSnackBar.success("Visit_started_successfully".tr);
      } else {
        AppSnackBar.error("Failed_to_start_visit".tr);
      }
    } catch (e) {
      AppSnackBar.error("Failed_to_start_visit_please_try_again".tr);
    } finally {
      isStartingVisit.value = false;
    }
  }

  /// Update Visit Status & Sync Plan directly from API Response
  Future<void> updateVisitStatus(
      int visitId,
      String status,
      String cause, {
        String? notes,
      }) async {
    try {
      isUpdatingStatus.value = true;

 /*     print(" Sending updateVisitStatus with parameters:");
      print("  - visitId: $visitId");
      print("  - status: $status");
      print("  - cause: $cause");
      print("  - notes: $notes");
      print("  - lat: ${currentMapController.latitude.value}");
      print("  - lng: ${currentMapController.longitude.value}");*/

      final res = await RouteStepService.updateVisitStatus(
        visitId: visitId,
        status: status,
        cause: cause,
        notes: notes,
        longitude: currentMapController.longitude.value,
        latitude: currentMapController.latitude.value,
      );

      //  طباعة الاستجابة القادمة من الـ API
      print(" updateVisitStatus API Response: $res");

      if (res != null &&
          (res['isSuccess'] == true || res['statusCode'] == 200)) {
        Get.back();
        AppSnackBar.success("Visit status updated successfully.".tr);

        // تحديث بيانات الخطة ورسم الخريطة فوراً باستخدام Response Data
        if (res['data'] != null) {
          final trackingController =
          Get.find<ActiveOptimizedRouteTrackingController>();
          trackingController.updatePlanFromStatusResponse(res['data']);
        }
      } else {
        final errorMsg = res?['message'] ?? "Failed to update status.";
        print("⚠️ Failed to update status response: $errorMsg");
        AppSnackBar.error(errorMsg);
      }
    } catch (e, stackTrace) {

      print("Exception in updateVisitStatus: $e");
      print("StackTrace: $stackTrace");
      AppSnackBar.error("Failed to update status, please try again.".tr);
    } finally {
      isUpdatingStatus.value = false;
    }
  }
}

