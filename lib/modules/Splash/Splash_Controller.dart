
import 'package:get/get.dart';
import 'dart:async';

class SplashController extends GetxController {
  final imageSize = 25.0.obs;
  final nameApp = 'INTELLI_PHARMA'.tr;
  final displayedText = ''.obs;
  Timer? _timer;
  int _charIndex = 0;

  @override
  void onInit() {
    super.onInit();

    /// Enlarge the logo
    Future.delayed(const Duration(milliseconds: 200), () {
      imageSize.value = 300.0;
    });

    /// Start writing the name letter by letter
    Future.delayed(const Duration(milliseconds: 700), () {
      _startTyping();
    });

    ///Go to the login Screen
    Future.delayed(const Duration(seconds: 4), () {
      _timer?.cancel();
       Get.offNamed('/signIn');
    });
  }

  void _startTyping() {
    _timer = Timer.periodic(const Duration(milliseconds: 90), (timer) {
      if (_charIndex < nameApp.length) {
        displayedText.value += nameApp[_charIndex];
        _charIndex++;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
