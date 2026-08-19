import 'package:get/get.dart';
import '../../services/ServiceApi/RouteStepService.dart';
import '../../widgets/AppSnackBar.dart';
class RouteStepController extends GetxController {
  var isStartingVisit = false.obs;
  var isUpdatingStatus = false.obs;

  /// Start of visit
  Future<void> startVisit(int visitId) async {
    try {
      isStartingVisit.value = true;

      final res = await RouteStepService.startVisit(visitId);

      if (res['isSuccess'] == true || res['statusCode'] == 200) {
        AppSnackBar.success("Visit_started_successfully".tr);
      } else {
        AppSnackBar.error("Failed_to_start_visit".tr);
        //print("Failed to start visit= ${res['message']}");
      }
    } catch (e) {
      AppSnackBar.error("Failed_to_start_visit_please_try_again".tr);
    } finally {
      isStartingVisit.value = false;
    }
  }

  /// تحديث حالة الزيارة مع السبب والنوتس
  Future<void> updateVisitStatus(
    int visitId,
    String status,
    String cause, {
    String? notes,
  }) async {
    try {
      isUpdatingStatus.value = true;

      final res = await RouteStepService.updateVisitStatus(
        visitId: visitId,
        status: status,
        cause: cause,
        notes: notes,
      );

      if (res != null &&
          (res['isSuccess'] == true || res['statusCode'] == 200)) {
        Get.back();
        AppSnackBar.success("Visit status updated successfully.");
      } else {
        AppSnackBar.error(res?['message'] ?? "Failed to update status.");
      }
    } catch (e) {
      AppSnackBar.error("Failed to update status, please try again.");
    } finally {
      isUpdatingStatus.value = false;
    }
  }
}
