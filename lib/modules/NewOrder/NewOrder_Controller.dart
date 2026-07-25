/*
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/AppSnackBar.dart';
import '../../Widgets/PharmacySelector/PharmacyList_Controller.dart';
import '../../services/ServiceApi/OrderService.dart';
import '../AddOrder/AddOrder_Model.dart';
import 'CartItem.dart';

class NewOrderController extends GetxController {
  final notesController = TextEditingController();
  RxBool isSubmitting = false.obs;

  RxList<CartItem> cart = <CartItem>[].obs;
  int get cartCount => cart.length;

  void addToCart(MedicineModel med, int qty) {
    if (qty <= 0) {
      AppSnackBar.error("Quantity is 0");
      return;
    }

    if (qty > med.availableQuantity) {
      AppSnackBar.error("Not enough stock");
      return;
    }

    final index = cart.indexWhere((e) => e.medicine.id == med.id);

    if (index == -1) {
      cart.add(CartItem(medicine: med, quantity: qty));
    } else {
      cart[index].quantity += qty;
      cart.refresh();
    }

    AppSnackBar.success("Added to cart successfully");
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

  double get totalPrice {
    return cart.fold(0, (sum, item) => sum + item.totalPrice);
  }

  Future<void> submitOrder() async {
    try {
      final pharmacyController = Get.find<PharmacySelectorController>();

      final pharmacy = pharmacyController.selectedPharmacy.value;

      if (pharmacy == null) {
        AppSnackBar.error("Please select pharmacy");
        return;
      }

      if (cart.isEmpty) {
        AppSnackBar.error("Cart is empty");
        return;
      }

      isSubmitting.value = true;

      final items = cart.map((item) {
        return {"medicine_id": item.medicine.id, "quantity": item.quantity};
      }).toList();

      final response = await OrderService.createOrder(
        pharmacyId: pharmacy.id,
        items: items,
        notes: notesController.text.trim(),
      );

      if (response["isSuccess"] == true) {
        AppSnackBar.success("Order created successfully");
        cart.clear();
        notesController.clear();

        pharmacyController.selectedPharmacy.value = null;
      }
    } catch (e) {
      AppSnackBar.error("Failed to create order");
      if (e is DioException && e.response != null) {
        print("Status Code: ${e.response?.statusCode}");
        print("Server Response Data: ${e.response?.data}");
      } else {
       // print(e);
      }
      //print(e);
    } finally {
      isSubmitting.value = false;
    }
  }
}
*/
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/AppSnackBar.dart';
import '../../Widgets/PharmacySelector/PharmacyList_Controller.dart';
import '../../services/ServiceApi/OrderService.dart';
import '../AddOrder/AddOrder_Model.dart';
import 'CartItem.dart';

class NewOrderController extends GetxController {
  final notesController = TextEditingController();
  RxBool isSubmitting = false.obs;

  RxList<CartItem> cart = <CartItem>[].obs;
  int get cartCount => cart.length;

  @override
  void onClose() {
    // 🟢 تنظيف الـ Controller لمنع Memory Leak
    notesController.dispose();
    super.onClose();
  }

  void addToCart(MedicineModel med, int qty) {
    if (qty <= 0) {
      AppSnackBar.error("Quantity is 0");
      return;
    }

    if (qty > med.availableQuantity) {
      AppSnackBar.error("Not enough stock");
      return;
    }

    final index = cart.indexWhere((e) => e.medicine.id == med.id);

    if (index == -1) {
      cart.add(CartItem(medicine: med, quantity: qty));
    } else {
      cart[index].quantity += qty;
      cart.refresh();
    }

    AppSnackBar.success("Added to cart successfully");
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
    cart.refresh();
  }

  double get totalPrice {
    return cart.fold(0, (sum, item) => sum + item.totalPrice);
  }

  Future<void> submitOrder() async {
    // 🟢 لمنع التكرار في حال الضغط أثناء التحميل
    if (isSubmitting.value) return;

    try {
      final pharmacyController = Get.find<PharmacySelectorController>();
      final pharmacy = pharmacyController.selectedPharmacy.value;

      if (pharmacy == null) {
        AppSnackBar.error("Please select pharmacy");
        return;
      }

      if (cart.isEmpty) {
        AppSnackBar.error("Cart is empty");
        return;
      }

      isSubmitting.value = true;

      final items = cart.map((item) {
        return {"medicine_id": item.medicine.id, "quantity": item.quantity};
      }).toList();

      final response = await OrderService.createOrder(
        pharmacyId: pharmacy.id,
        items: items,
        notes: notesController.text.trim(),
      );

      if (response["isSuccess"] == true) {
        AppSnackBar.success("Order created successfully");
        cart.clear();
        notesController.clear();
        pharmacyController.selectedPharmacy.value = null;

        // 🟢 اختياري: العودة للشاشة السابقة بعد نجاح الطلب
        Get.back();
      }
    } catch (e) {
      AppSnackBar.error("Failed to create order");
      if (e is DioException && e.response != null) {
        print("Status Code: ${e.response?.statusCode}");
        print("Server Response Data: ${e.response?.data}");
      }
    } finally {
      isSubmitting.value = false;
    }
  }
}