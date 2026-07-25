

import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../modules/AddOrder/AddOrder_Controller.dart';
import '../modules/HomeContent/HomeContent_Controller.dart';
import '../modules/HomeContentDistributor/HomeContentDistributor_Controller.dart';
import '../modules/MyDeliveries/MyDeliveries_Controller.dart';
import '../modules/MyOrders/MyOrders_Controller.dart';
import '../modules/Pharmacists/Pharmacists_Controller.dart';

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
    Get.forceAppUpdate();

    if (Get.isRegistered<HomeContentController>()) {
      Get.find<HomeContentController>().getHomePage();
    }

    if (Get.isRegistered<AddOrderController>()) {
      final addOrderController = Get.find<AddOrderController>();
      addOrderController.fetchCategories();
      addOrderController.fetchMedicines();
    }

    if (Get.isRegistered<MyOrdersController>()) {
      Get.find<MyOrdersController>().fetchOrders();
    }
    if (Get.isRegistered<PharmacistsController>()) {
      Get.find<PharmacistsController>().fetchPharmacies();
    }
    if (Get.isRegistered<MyDeliveriesController>()) {
      Get.find<MyDeliveriesController>().fetchDeliveries();
    }
    if (Get.isRegistered<DeliveryHomeController>()) {
      Get.find<DeliveryHomeController>().fetchDeliveryHome();
    }

  }
}