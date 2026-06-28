
import 'package:get/get.dart';
class CustomBottomNavController extends GetxController {
  var currentIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
    currentIndex.value = 0;
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}