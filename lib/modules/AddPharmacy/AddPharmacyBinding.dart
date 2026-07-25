import 'package:get/get.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import 'AddPharmacy_Controller.dart';

class AddPharmacyBinding extends Bindings {
  @override
  void dependencies() {
    // 1. حقن AddPharmacyController
    Get.lazyPut<AddPharmacyController>(
          () => AddPharmacyController(),
      fenix: true,
    );

    // 2. حقن MapHelperController للـ tag المخصص للخريطة "addPharmacy"
    Get.lazyPut<MapHelperController>(
          () => MapHelperController(),
      tag: "addPharmacy",
      fenix: true,
    );
  }
}