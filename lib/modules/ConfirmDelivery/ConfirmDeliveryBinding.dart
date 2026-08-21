import 'package:get/get.dart';
import '../ActiveDeliveryRoute/ActiveDeliveryRoute_Model.dart';
import 'ConfirmDelivery_Controller.dart';
/*

class ConfirmDeliveryBinding extends Bindings {
  @override
  void dependencies() {
    // 🟢 استلام الـ visit الممررة عبر Get.arguments
    final DeliveryVisit visit = Get.arguments['visit'];

    Get.lazyPut<ConfirmDeliveryController>(
          () => ConfirmDeliveryController(visit: visit),
    );
  }
}*/

class ConfirmDeliveryBinding extends Bindings {
  @override
  void dependencies() {
    // 🟢 قراءة الـ arguments بآمان
    final Map<String, dynamic> args = Get.arguments ?? {};
    final DeliveryVisit? visit = args['visit'];

    if (visit == null) {
      print("ERROR: No visit object passed to ConfirmDeliveryBinding!");
      return;
    }

    // 🟢 إزالة أي نسخة قديمة مخزنة في الذاكرة للـ Controller
    if (Get.isRegistered<ConfirmDeliveryController>()) {
      Get.delete<ConfirmDeliveryController>();
    }

    // 🟢 إنشاء الكنترولر فوراً مع الـ visit الخاصة بالزيارة الحالية
    Get.put<ConfirmDeliveryController>(
      ConfirmDeliveryController(visit: visit),
    );
  }
}