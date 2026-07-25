
import 'package:get/get.dart';
import 'MyOrders_Controller.dart';

class MyOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyOrdersController>(
          () => MyOrdersController(),
      fenix: true,
    );
  }
}