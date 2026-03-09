
import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyLanguageController extends GetxController {
  final GetStorage box = GetStorage();
  late Rx<Locale> intiLanguage;

  @override
  void onInit() {
    super.onInit();
    String? langCode = box.read("lang");
    intiLanguage = Rx((langCode == "ar") ? const Locale("ar") : const Locale("en"));
  }

  void changeLanguage(String codeLang) {
    Locale locale = Locale(codeLang);
    box.write("lang", codeLang);
    intiLanguage.value = locale;
    Get.updateLocale(locale);
  }
}
