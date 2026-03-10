
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_theme/AppColors.dart';
import '../app_theme/theme_controller.dart';
class ForgotPasswordComponent extends StatelessWidget {
  const ForgotPasswordComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: themeController.isDarkMode.value
                    ? AppColors.componentDark
                    : AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),

                ),
                title: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      "Note".tr,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                content: Text(
                  "YouCannotChangeYourPassword".tr,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          child: Text(
            "ForgotPassword".tr,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Cairo',
            ),
          ),
        ),

      ],
    );
  }
}
