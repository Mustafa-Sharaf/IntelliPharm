

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackBar {
  static void error(String message) {
    Get.snackbar(
      "Error".tr,
      message,
      backgroundColor: Colors.redAccent.shade400,
      colorText: Colors.white,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }

  static void success(String message) {
    Get.snackbar(
      "Success".tr,
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }
}