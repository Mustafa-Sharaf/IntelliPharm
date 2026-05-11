
import 'package:get/get.dart';
import '../AddOrder/AddOrder_Model.dart';
import 'CartItem.dart';

class NewOrderController extends GetxController {
  /// cart (MAIN)
  RxList<CartItem> cart = <CartItem>[].obs;

  void addToCart(MedicineModel med, int qty) {
    print("ADD TO CART CALLED");
    print("QTY = $qty");

    if (qty <= 0) {
      Get.snackbar("Error", "Quantity is 0");
      return;
    }

    if (qty > med.availableQuantity) {
      Get.snackbar("Error", "Not enough stock");
      return;
    }

    final index = cart.indexWhere((e) => e.medicine.id == med.id);

    if (index == -1) {
      cart.add(CartItem(medicine: med, quantity: qty));
    } else {
      cart[index].quantity += qty;
      cart.refresh();
    }

    print("CART SIZE = ${cart.length}");
  }

  void increase(CartItem item) {
    if (item.quantity < item.medicine.availableQuantity) {
      item.quantity++;
      cart.refresh();
    }
  }

  void decrease(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      cart.remove(item);
    }
    cart.refresh();
  }

  void removeItem(CartItem item) {
    cart.remove(item);
  }
}
