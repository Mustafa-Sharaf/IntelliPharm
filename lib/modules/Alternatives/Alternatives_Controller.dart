import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/ServiceApi/MedicineService.dart';
import '../AddOrder/AddOrder_Model.dart';
import 'Alternatives_Model.dart';


class AlternativesController extends GetxController {
  final int medicineId;
  AlternativesController(this.medicineId);

  RxBool isLoading = true.obs;
  RxList<MedicineModel> alternatives = <MedicineModel>[].obs;
  RxMap<int, TextEditingController> qtyControllers = <int, TextEditingController>{}.obs;

  TextEditingController getController(int id) {
    if (!qtyControllers.containsKey(id)) {
      qtyControllers[id] = TextEditingController();
    }
    return qtyControllers[id]!;
  }

  @override
  void onInit() {
    super.onInit();
    fetchAlternatives();
  }

  Future<void> fetchAlternatives() async {
    try {
      isLoading.value = true;
      final response = await MedicineService.getMedicineDetails(medicineId);
      final details = MedicineDetailsModel.fromJson(response);
      alternatives.value = details.alternatives;
    } catch (e) {
      print("ERROR FETCHING ALTERNATIVES: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void decreaseStock(int id, int qty) {
    final index = alternatives.indexWhere((m) => m.id == id);
    if (index != -1) {
      final med = alternatives[index];
      final newQty = med.availableQuantity - qty;
      alternatives[index] = MedicineModel(
        id: med.id,
        categoryId: med.categoryId,
        commercialName: med.commercialName,
        scientificName: med.scientificName,
        price: med.price,
        isImported: med.isImported,
        availableQuantity: newQty < 0 ? 0 : newQty,
        barcode: med.barcode,
        images: med.images,
        gift: med.gift,
      );
      alternatives.refresh();
    }
  }

  @override
  void onClose() {
    for (var controller in qtyControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }
}