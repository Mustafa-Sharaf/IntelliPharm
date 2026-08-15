import 'package:get/get.dart';
import 'ActiveOptimizedRouteTracking_Controller.dart';

class ActiveOptimizedRouteTrackingBinding extends Bindings {
  @override
  void dependencies() {
    // 1. حقن ActiveOptimizedRouteTrackingController
    Get.lazyPut<ActiveOptimizedRouteTrackingController>(
          () => ActiveOptimizedRouteTrackingController(),
      fenix: true,
    );

  }
}