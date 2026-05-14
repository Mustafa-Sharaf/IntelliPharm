import 'package:get/get.dart';
import '../../services/ServiceApi/OrderDetailsService.dart';
import 'ShowOrder_Model.dart';


class OrderDetailsController extends GetxController {
  final int orderId;

  OrderDetailsController(this.orderId);

  var isLoading = false.obs;
  Rxn<OrderDetailsModel> order = Rxn<OrderDetailsModel>();

  @override
  void onInit() {
    fetchOrderDetails();
    super.onInit();
  }

  void fetchOrderDetails() async {
    isLoading.value = true;

    try {
      final data = await OrderDetailsService.getOrderDetails(orderId);
      order.value = data;
    } catch (e) {
      print("Order details error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}