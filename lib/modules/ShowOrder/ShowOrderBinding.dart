
import 'package:get/get.dart';
import 'ShowOrder_Controller.dart';

class ShowOrderBinding extends Bindings {
  final int orderId;

  ShowOrderBinding(this.orderId);

  @override
  void dependencies() {
    Get.lazyPut<OrderDetailsController>(
          () => OrderDetailsController(orderId),
      tag: orderId.toString(),
    );
  }
}