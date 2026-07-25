
import 'package:get/get.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import 'RePlanRoute_Controller.dart';

class RePlanRouteBinding extends Bindings {
  @override
  void dependencies() {
    // 1. التأكد من وجود MapHelperController الخاص بالخريطة مع Tag "route"
    if (!Get.isRegistered<MapHelperController>(tag: "route")) {
      Get.lazyPut<MapHelperController>(
            () => MapHelperController(),
        tag: "route",
      );
    }

    // 2. حقن RePlanRouteController
    Get.lazyPut<RePlanRouteController>(
          () => RePlanRouteController(),
    );
  }
}