import 'package:get/get.dart';
import '../ActiveDeliveryRoute/ActiveDeliveryRoute_Model.dart';
import 'ConfirmDelivery_Controller.dart';

class ConfirmDeliveryBinding extends Bindings {
  @override
  void dependencies() {
    // 🟢 استلام الـ visit الممررة عبر Get.arguments
    final DeliveryVisit visit = Get.arguments['visit'];

    Get.lazyPut<ConfirmDeliveryController>(
          () => ConfirmDeliveryController(visit: visit),
    );
  }
}