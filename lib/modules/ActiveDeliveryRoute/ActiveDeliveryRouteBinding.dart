
import 'package:get/get.dart';

import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import 'ActiveDeliveryRoute_Controller.dart';

class ActiveDeliveryRouteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActiveDeliveryRouteController>(
          () => ActiveDeliveryRouteController(),
      fenix: true,
    );
    Get.lazyPut<MapHelperController>(
          () => MapHelperController(),
      tag: "routeDelivery",
      fenix: true,
    );
  }
}