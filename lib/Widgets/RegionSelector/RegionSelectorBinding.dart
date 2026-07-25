import 'package:get/get.dart';
import 'RegionSelector_Controller.dart';

class RegionSelectorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegionController>(
          () => RegionController(),
    );
  }
}