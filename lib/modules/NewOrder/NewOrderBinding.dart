import 'package:get/get.dart';
import '../../Widgets/PharmacySelector/PharmacyList_Controller.dart';

class NewOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PharmacySelectorController>(
          () => PharmacySelectorController(),
    );
  }
}