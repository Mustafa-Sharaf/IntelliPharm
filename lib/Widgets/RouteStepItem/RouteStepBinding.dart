import 'package:get/get.dart';
import 'RouteStepController.dart';

class RouteStepBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RouteStepController>(() => RouteStepController(), fenix: true);
  }
}