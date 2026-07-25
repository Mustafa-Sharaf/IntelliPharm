
import 'package:get/get.dart';

import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import 'ActiveDeliveryRoute_Controller.dart';

class ActiveDeliveryRouteBinding extends Bindings {
  @override
  void dependencies() {
    // 1. حقن ActiveDeliveryRouteController
    Get.lazyPut<ActiveDeliveryRouteController>(
          () => ActiveDeliveryRouteController(),
      fenix: true,
    );

    // 2. حقن MapHelperController مع الـ tag الخاص به
    Get.lazyPut<MapHelperController>(
          () => MapHelperController(),
      tag: "route",
      fenix: true,
    );
  }
}