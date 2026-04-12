/*
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
}*/
/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/ApiService.dart';
import 'AddOrder_Model.dart';

class AddOrderController extends GetxController {
  /// Controllers
  var pharmacyNameController = TextEditingController();
  var quantityController = TextEditingController();
  var searchController = TextEditingController();
  var commentController = TextEditingController();

  /// Data
  //var medicines = <MedicineModel>[].obs;
  var selectedMedicine = Rxn<MedicineModel>();
  var orders = <Map<String, dynamic>>[].obs;

  var showDropdown = false.obs;
  var isLoading = false.obs;

  var medicines = <MedicineModel>[].obs;
  //var showDropdown = false.obs;
  Timer? _debounce;

  /// ================= FETCH FROM API =================
  Future<void> fetchMedicines({String query = ''}) async {
    try {
      isLoading.value = true;

      final response = await ApiService.get(
        '/erp/v1/medicines',
        query: {"per_page": 5, if (query.isNotEmpty) "search": query},
      );

      if (response.data["isSuccess"]) {
        final List data = response.data["data"]["data"];

        medicines.value = data.map((e) => MedicineModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }


  /// ================= SEARCH (SERVER SIDE) =================
  void onSearchChanged(String value) {
    showDropdown.value = true;

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchMedicines(query: value);
    });
  }





  /// ================= SELECT =================
  void selectMedicine(MedicineModel med) {
    selectedMedicine.value = med;
    searchController.text = med.name;
  }

  /// ================= ADD ORDER =================
  void tryAddOrder() {
    if (selectedMedicine.value == null || quantityController.text.isEmpty) {
      return;
    }

    int? qty = int.tryParse(quantityController.text);
    if (qty == null) return;

    final med = selectedMedicine.value!;

    /// ❌ تحقق الكمية
    if (qty > med.availableQuantity) {
      Get.snackbar(
        "Error",
        "Only ${med.availableQuantity} available",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    int index = orders.indexWhere((e) => e["id"] == med.id);

    if (index != -1) {
      orders[index]["qty"] += qty;
      orders.refresh();
    } else {
      orders.add({
        "id": med.id,
        "name": med.name,
        "price": med.price,
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
*/
