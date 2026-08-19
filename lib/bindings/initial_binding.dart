import 'package:get/get.dart';
import '../app_theme/theme_controller.dart';
import '../language/Language_Controller.dart';
import '../modules/NewOrder/NewOrder_Controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
   
    Get.put(MyLanguageController(), permanent: true);
    Get.put(ThemeController(), permanent: true);
    Get.put(NewOrderController(), permanent: true);
  }
}