import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;
  final _box = GetStorage();
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _box.write('isDarkMode', isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
  void setInitialTheme(bool isDark) {
    isDarkMode.value = isDark;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
  void loadThemeFromStorage() {
    bool? storedTheme = _box.read('isDarkMode');
    if (storedTheme != null) {
      setInitialTheme(storedTheme);
    }
  }
}
