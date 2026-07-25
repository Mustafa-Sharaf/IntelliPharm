import 'package:get/get.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../PlanYourRoute/PlanYourRoute_Controller.dart';
import '../Tracking/LiveLocationTracker.dart';
import 'ActiveOptimizedRouteTracking_Controller.dart';

class ActiveOptimizedRouteTrackingBinding extends Bindings {
  @override
  void dependencies() {
    // 1. حقن ActiveOptimizedRouteTrackingController
    Get.lazyPut<ActiveOptimizedRouteTrackingController>(
          () => ActiveOptimizedRouteTrackingController(),
      fenix: true,
    );

    // 2. ضمان وجود PlanYourRouteController لأن الشاشة والكونترولر يعتمدان عليه
/*    if (!Get.isRegistered<PlanYourRouteController>()) {
      Get.put(PlanYourRouteController(), permanent: true);
    }

    if (!Get.isRegistered<LiveLocationTracker>()) {
      Get.put(LiveLocationTracker(), permanent: true);
    }*/

    // 4. حقن MapHelperController للـ Tag المخصص "route"
 /*   Get.lazyPut<MapHelperController>(
          () => MapHelperController(),
      tag: "route",
      fenix: true,
    );*/
  }
}