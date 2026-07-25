
import 'package:get/get.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import 'PlanYourRoute_Controller.dart';

class PlanYourRouteBinding extends Bindings {
  @override
  void dependencies() {
    // 1. ضمان وجود MapHelperController الخاص بالمسار
    if (!Get.isRegistered<MapHelperController>(tag: "route")) {
      Get.lazyPut<MapHelperController>(
            () => MapHelperController(),
        tag: "route",
      );
    }

    // 2. حقن PlanYourRouteController الرئيسي
    Get.lazyPut<PlanYourRouteController>(
          () => PlanYourRouteController(),
    );
  }
}