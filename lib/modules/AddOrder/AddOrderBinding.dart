import 'package:get/get.dart';
import '../NewOrder/NewOrder_Controller.dart';
import 'AddOrder_Controller.dart';

class AddOrderBinding extends Bindings {
  @override
  void dependencies() {
    // 1. حقن AddOrderController المسؤول عن جلب الأدوية والتصنيفات
    Get.lazyPut<AddOrderController>(
          () => AddOrderController(),
      fenix: true,
    );

    // 2. حقن NewOrderController المسؤول عن إداريات السلة (Cart)
    Get.lazyPut<NewOrderController>(
          () => NewOrderController(),
      fenix: true,
    );
  }
}