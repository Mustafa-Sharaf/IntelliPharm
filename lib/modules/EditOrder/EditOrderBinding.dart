import 'package:get/get.dart';

import '../ShowOrder/ShowOrder_Model.dart';
import 'EditOrderController.dart';


class EditOrderBinding extends Bindings {
  final int orderId;
  final OrderDetailsModel order;

  EditOrderBinding({required this.orderId, required this.order});

  @override
  void dependencies() {
    Get.lazyPut<EditOrderController>(
          () => EditOrderController(orderId, order),
      tag: orderId.toString(),
    );
  }
}