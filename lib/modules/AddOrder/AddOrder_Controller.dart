
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddOrderController extends GetxController {
  var pharmacyNameController = TextEditingController();
  var quantityController = TextEditingController();
  var searchController = TextEditingController();
  var commentController = TextEditingController();

  var medicines = [
    {"name": "Paracetamol", "price": 5},
    {"name": "Ibuprofen", "price": 7},
    {"name": "Amoxicillin", "price": 12},
    {"name": "Aspirin", "price": 4},
    {"name": "Vitamin C", "price": 6},
    {"name": "Panadol", "price": 5},
    {"name": "Augmentin", "price": 15},
    {"name": "Cough Syrup", "price": 8},
    {"name": "Insulin", "price": 25},
    {"name": "Metformin", "price": 10},
  ];

  var filteredMedicines = <Map<String, dynamic>>[].obs;
  var selectedMedicine = Rxn<Map<String, dynamic>>();
  var orders = <Map<String, dynamic>>[].obs;

  var showDropdown = false.obs;

  @override
  void onInit() {
    super.onInit();
    filteredMedicines.assignAll(medicines);
  }

  /// فلترة
  void filterMedicines(String query) {
    showDropdown.value = true;

    if (query.isEmpty) {
      filteredMedicines.assignAll(medicines);
    } else {
      filteredMedicines.assignAll(
        medicines.where((med) =>
            (med["name"] as String)
                .toLowerCase()
                .contains(query.toLowerCase())),
      );
    }
  }

  /// إضافة مع دمج
  void tryAddOrder() {
    if (selectedMedicine.value == null ||
        quantityController.text.isEmpty) return;

    int? qty = int.tryParse(quantityController.text);
    if (qty == null) return;

    String name = selectedMedicine.value!["name"];
    int price = selectedMedicine.value!["price"];

    /// 🔥 إذا موجود مسبقاً ➜ زيد الكمية
    int index = orders.indexWhere((e) => e["name"] == name);

    if (index != -1) {
      orders[index]["qty"] += qty;
      orders.refresh(); // مهم
    } else {
      orders.add({
        "name": name,
        "price": price,
        "qty": qty,
      });
    }

    /// reset
    selectedMedicine.value = null;
    quantityController.clear();
    searchController.clear();
    showDropdown.value = false;
  }

  void removeOrder(int index) {
    orders.removeAt(index);
  }

  double get totalPrice {
    double total = 0;
    for (var item in orders) {
      total += item["price"] * item["qty"];
    }
    return total;
  }

  void closeDropdown() {
    showDropdown.value = false;
  }
}