import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/ServiceApi/CategoryService.dart';
import '../../services/ServiceApi/MedicineService.dart';
import 'AddOrder_Model.dart';
import 'CategoryModel.dart';

class AddOrderController extends GetxController {
  /// search
  RxString searchQuery = ''.obs;

  /// medicines
  RxList<MedicineModel> medicines = <MedicineModel>[].obs;

  /// categories
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  /// loading
  RxBool isLoading = false.obs;
  RxBool isPaginationLoading = false.obs;

  /// pagination
  int currentPage = 1;
  int lastPage = 1;

  /// selected tab
  var selectedTab = 0.obs;
  int? selectedCategoryId;

  /// debounce
  Timer? _debounce;

  RxMap<int, TextEditingController> qtyControllers =
      <int, TextEditingController>{}.obs;

  TextEditingController getController(int id) {
    if (!qtyControllers.containsKey(id)) {
      qtyControllers[id] = TextEditingController();
    }
    return qtyControllers[id]!;
  }

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchMedicines();
  }

  /// ================= CATEGORIES =================

  Future<void> fetchCategories() async {
    final response = await CategoryService.getCategories(page: 1);

    final List list = response['data']['data'];

    categories.value = list.map((e) => CategoryModel.fromJson(e)).toList();
  }

  void changeTab(int index) {
    selectedTab.value = index;
    selectedCategoryId = categories[index].id;
    fetchMedicines();
  }

  /// ================= MEDICINES =================

  Future<void> fetchMedicines({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isPaginationLoading.value = true;
    } else {
      isLoading.value = true;
      currentPage = 1;
    }

    final response = await MedicineService.getMedicines(
      page: currentPage,
      query: searchQuery.value,
      categoryId: selectedCategoryId,
    );

    final data = response['data'];
    final List list = data['data'];

    medicines.value = list.map((e) => MedicineModel.fromJson(e)).toList();

    lastPage = data['meta']['last_page'];

    isLoading.value = false;
    isPaginationLoading.value = false;
  }

  /// search
  void onSearchChanged(String value) {
    searchQuery.value = value;

    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => fetchMedicines(),
    );
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
