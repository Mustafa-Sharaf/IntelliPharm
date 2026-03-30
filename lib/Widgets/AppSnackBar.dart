

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackBar {
  static void error(String message) {
    Get.snackbar(
      "Error".tr,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  static void success(String message) {
    Get.snackbar(
      "Success".tr,
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}