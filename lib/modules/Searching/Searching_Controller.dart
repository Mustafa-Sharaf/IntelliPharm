



import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../services/ApiService.dart';
import '../AddOrder/AddOrder_Model.dart';
import 'Searching_Model.dart';


class SearchingController extends GetxController {
  var searchController = TextEditingController();

  var medicines = <Medicine>[].obs;
  var isLoading = false.obs;

  Timer? _debounce;
  int page = 1;

  @override
  void onInit() {
    fetchMedicines();
    super.onInit();
  }

  /// 🔥 API
  Future<void> fetchMedicines({String query = ""}) async {
    try {
      isLoading.value = true;

      final response = await ApiService.get(
        "/erp/v1/medicines",
        query: {
          "page_number": page,
          "per_page": 15,
          // خليها بس إذا backend يدعمها
          "search": query,
        },
      );

      if (response.data["isSuccess"]) {
        final List list = response.data["data"]["data"];

        medicines.value =
            list.map((e) => Medicine.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch medicines");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔥 Debounced Search (احترافي)
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
/*class SearchingController  extends GetxController{


  var searchController = TextEditingController();

  var medicines = <Medicine>[].obs;
  var isLoading = false.obs;

  int page = 1;

  /// 🔥 جلب الأدوية من السيرفر
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

        medicines.value =
            list.map((e) => Medicine.fromJson(e)).toList();
      }
    } catch (e) {
      print("❌ Error: $e");
      Get.snackbar("Error", "Failed to fetch medicines");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔍 عند البحث
  void onSearch() {
    page = 1;
    fetchMedicines(query: searchController.text);
  }

  @override
  void onInit() {
    fetchMedicines();
    super.onInit();
  }
}*/



/*var isLoading = false.obs;
  var medicines = <MedicineModel>[].obs;
  var showDropdown = false.obs;
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
  }*/
