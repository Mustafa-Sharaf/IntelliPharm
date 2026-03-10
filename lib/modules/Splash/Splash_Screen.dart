
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/AppColors.dart';
import 'splash_controller.dart';
class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());
    return Scaffold(
      backgroundColor: AppColors.backgroundColorLight1,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// LOGO
            Obx(() => AnimatedScale(
              scale: controller.imageSize.value / 260,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutBack,
              child: Image.asset(
                'assets/images/Logo without a name.png',
                width: 160,
              ),
            )),
            SizedBox(height: 8,),
            ///Name by Animation
            Obx(() => Text(
              controller.displayedText.value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryColor,
                fontFamily: 'Cairo',
              ),
            )),
          ],
        ),
      ),
    );
  }
}

