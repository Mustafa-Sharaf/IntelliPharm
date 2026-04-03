import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../services/ApiService.dart';
import 'Searching_Model.dart';

class SearchingController extends GetxController {
  var searchController = TextEditingController();

  var medicines = <Medicine>[].obs;
  var isLoading = false.obs;

  Timer? _debounce;
  int page = 1;

  @override
  void onInit() {
    //fetchMedicines();
    super.onInit();
  }


  Future<void> fetchMedicines({String query = ""}) async {
    try {
      isLoading.value = true;

      final response = await ApiService.get(
        "/erp/v1/medicines",
        query: {
          "page_number": page,
          "per_page": 15,
          "search": query,
        },
      );

      if (response.data["isSuccess"]) {
        final List list = response.data["data"]["data"];

        medicines.value = list.map((e) => Medicine.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch medicines");
    } finally {
      isLoading.value = false;
    }
  }


  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      page = 1;
      fetchMedicines(query: value);
    });
  }

  void onSearchSubmit() {
    page = 1;
    fetchMedicines(query: searchController.text);
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
