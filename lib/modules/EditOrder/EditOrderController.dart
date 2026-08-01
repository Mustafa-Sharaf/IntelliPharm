import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/AppSnackBar.dart';
import '../../services/ServiceApi/EditOrderService.dart';
import '../../services/ServiceApi/MedicineService.dart';
import '../AddOrder/AddOrder_Model.dart';
import '../ShowOrder/ShowOrder_Controller.dart';
import '../ShowOrder/ShowOrder_Model.dart';

class EditableOrderItem {
  final int medicineId;
  final String medicineName;
  RxInt quantity;
  final String unitPrice;

  EditableOrderItem({
    required this.medicineId,
    required this.medicineName,
    required int quantity,
    required this.unitPrice,
  }) : quantity = quantity.obs;
}

class EditOrderController extends GetxController {
  final int orderId;
  final OrderDetailsModel initialOrder;
  var isSearchingMedicines = false.obs;
  var searchResults = <MedicineModel>[].obs;
  RxMap<int, TextEditingController> searchQtyControllers = <int, TextEditingController>{}.obs;

  EditOrderController(this.orderId, this.initialOrder);

  var isLoading = false.obs;
  var items = <EditableOrderItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    for (var item in initialOrder.items) {
        items.add(
          EditableOrderItem(
            medicineId: item.medicineId,
            medicineName: item.medicineName,
            quantity: item.quantity,
            unitPrice: item.unitPrice,
          ),
        );
    }
  }

  void incrementQuantity(EditableOrderItem item) {
    item.quantity.value++;
  }

  void decrementQuantity(EditableOrderItem item) {
    if (item.quantity.value > 1) {
      item.quantity.value--;
    } else {
      removeItem(item);
    }
  }

  void removeItem(EditableOrderItem item) {
    items.remove(item);
  }

  void addNewMedicine(int medicineId, String name, String unitPrice, int qty) {
    final existingIndex = items.indexWhere((e) => e.medicineId == medicineId);
    if (existingIndex != -1) {
      items[existingIndex].quantity.value += qty;
    } else {
      items.add(
        EditableOrderItem(
          medicineId: medicineId,
          medicineName: name,
          quantity: qty,
          unitPrice: unitPrice,
        ),
      );
    }
  }

  Future<void> submitUpdate() async {
    if (items.isEmpty) {
      AppSnackBar.error("Cannot_submit_empty_order".tr);
      return;
    }
    isLoading.value = true;

    List<Map<String, dynamic>> payload = items
        .map((e) => {
      "medicine_id": e.medicineId,
      "quantity": e.quantity.value,
    })
        .toList();

    try {
      bool isSuccess = await EditOrderService.updateOrder(
        orderId: orderId,
        items: payload,
      );

      if (isSuccess) {
        Get.back(result: true);
        AppSnackBar.success("Order_updated_successfully".tr);

        if (Get.isRegistered<OrderDetailsController>(
            tag: orderId.toString())) {
          Get.find<OrderDetailsController>(tag: orderId.toString())
              .fetchOrderDetails();
        }
      }
    } catch (e) {
      String errorMessage = "Failed_to_update_order".tr;

      if (e is DioException && e.response?.data != null) {
        final responseData = e.response!.data;

        if (responseData is Map && responseData['errors'] != null) {
          final errors = responseData['errors'];
          if (errors is Map && errors['message'] != null) {
            errorMessage = errors['message'];
          } else if (errors is String) {
            errorMessage = errors;
          }
        }
      }

      AppSnackBar.error(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }


  void searchMedicinesToEdit(String query) async {
    isSearchingMedicines.value = true;

    try {
      final responseData = await MedicineService.getMedicines(
        page: 1,
        query: query.trim().isEmpty ? null : query,
      );

      List dynamicList = [];


      if (responseData is Map && responseData['data'] != null) {
        final innerData = responseData['data'];

        if (innerData is Map && innerData['data'] is List) {

          dynamicList = innerData['data'];
        } else if (innerData is List) {
          dynamicList = innerData;
        }
      } else if (responseData is List) {
        dynamicList = responseData;
      }

      List<MedicineModel> fetchedMedicines =
      dynamicList.map((e) => MedicineModel.fromJson(e)).toList();

      searchResults.assignAll(fetchedMedicines);
    } catch (e) {
      print("Error fetching medicines: $e");
      searchResults.clear();
    } finally {
      isSearchingMedicines.value = false;
    }
  }



  TextEditingController getMedicineQtyController(int id) {
    if (!searchQtyControllers.containsKey(id)) {
      searchQtyControllers[id] = TextEditingController();
    }
    return searchQtyControllers[id]!;
  }

  @override
  void onClose() {
    for (var c in searchQtyControllers.values) {
      c.dispose();
    }
    super.onClose();
  }

}