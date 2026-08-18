import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/ServiceApi/CategoryService.dart';
import '../../services/ServiceApi/MedicineService.dart';
import 'AddOrder_Model.dart';
import 'CategoryModel.dart';

class AddOrderController extends GetxController {
  RxString searchQuery = ''.obs;
  RxString categorySearchQuery = ''.obs;

  RxList<MedicineModel> medicines = <MedicineModel>[].obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  RxBool isLoading = false.obs;
  RxBool isPaginationLoading = false.obs;

  int categoryCurrentPage = 1;
  int categoryLastPage = 1;
  RxBool isCategoryPaginationLoading = false.obs;

  int currentPage = 1;
  int lastPage = 1;
  var selectedTypeTab = 0.obs;

  Rxn<int> selectedCategoryId = Rxn<int>();
  Timer? _debounce;

  final ScrollController scrollController = ScrollController();
  final ScrollController categoryScrollController = ScrollController();

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
    fetchCategories();
    fetchMedicines();

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        loadMoreMedicines();
      }
    });

    categoryScrollController.addListener(() {
      if (categoryScrollController.position.pixels >= categoryScrollController.position.maxScrollExtent - 50) {
        loadMoreCategories();
      }
    });
  }

  Future<void> fetchCategories() async {
    categoryCurrentPage = 1;
    try {
      final response = await CategoryService.getCategories(page: categoryCurrentPage);
      final List list = response['data']['data'];
      categories.value = list.map((e) => CategoryModel.fromJson(e)).toList();
      categoryLastPage = response['data']['meta']['last_page'] ?? 1;
    } catch (e) {
      print("ERROR FETCHING CATEGORIES: $e");
    }
  }

  Future<void> loadMoreCategories() async {
    if (isCategoryPaginationLoading.value || categoryCurrentPage >= categoryLastPage) return;

    isCategoryPaginationLoading.value = true;
    categoryCurrentPage++;

    try {
      final response = await CategoryService.getCategories(page: categoryCurrentPage);
      final List list = response['data']['data'];

      List<CategoryModel> fetchedCategories = list.map((e) => CategoryModel.fromJson(e)).toList();
      categories.addAll(fetchedCategories);

      categoryLastPage = response['data']['meta']['last_page'] ?? 1;
    } catch (e) {
      categoryCurrentPage--;
      print("ERROR LOADING MORE CATEGORIES: $e");
    } finally {
      isCategoryPaginationLoading.value = false;
    }
  }

  List<CategoryModel> get filteredCategories {
    if (categorySearchQuery.value.isEmpty) {
      return categories;
    }
    return categories.where((cat) {
      return cat.name.toLowerCase().contains(categorySearchQuery.value.toLowerCase());
    }).toList();
  }

  void selectCategory(int? categoryId) {
    selectedCategoryId.value = categoryId;
    fetchMedicines();
  }

  void changeTypeTab(int index) {
    selectedTypeTab.value = index;
    fetchMedicines();
  }

  Future<void> fetchMedicines() async {
    isLoading.value = true;
    currentPage = 1;

    try {
      final response = await MedicineService.getMedicines(
        page: currentPage,
        query: searchQuery.value,
        categoryId: selectedCategoryId.value,
      );

      final data = response['data'];
      final List list = data['data'];

      List<MedicineModel> fetchedMedicines = list.map((e) => MedicineModel.fromJson(e)).toList();

      if (selectedTypeTab.value == 1) {
        fetchedMedicines = fetchedMedicines.where((m) => !m.isImported).toList();
      } else if (selectedTypeTab.value == 2) {
        fetchedMedicines = fetchedMedicines.where((m) => m.isImported).toList();
      }

      medicines.value = fetchedMedicines;
      lastPage = data['meta']['last_page'] ?? 1;
    } catch (e) {
      print("ERROR FETCHING MEDICINES: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreMedicines() async {
    if (isPaginationLoading.value || currentPage >= lastPage) return;

    isPaginationLoading.value = true;
    currentPage++;

    try {
      final response = await MedicineService.getMedicines(
        page: currentPage,
        query: searchQuery.value,
        categoryId: selectedCategoryId.value,
      );

      final data = response['data'];
      final List list = data['data'];

      List<MedicineModel> fetchedMedicines = list.map((e) => MedicineModel.fromJson(e)).toList();

      if (selectedTypeTab.value == 1) {
        fetchedMedicines = fetchedMedicines.where((m) => !m.isImported).toList();
      } else if (selectedTypeTab.value == 2) {
        fetchedMedicines = fetchedMedicines.where((m) => m.isImported).toList();
      }

      medicines.addAll(fetchedMedicines);
      lastPage = data['meta']['last_page'] ?? 1;
    } catch (e) {
      currentPage--;
      print("ERROR LOADING MORE MEDICINES: $e");
    } finally {
      isPaginationLoading.value = false;
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
          () => fetchMedicines(),
    );
  }


  void decreaseStock(int medicineId, int quantity) {
    final index = medicines.indexWhere((m) => m.id == medicineId);
    if (index != -1) {
      final currentMed = medicines[index];
      final newQuantity = currentMed.availableQuantity - quantity;

      // نقوم بتحديث عنصر الدواء بالكمية المتبقية الجديدة
      medicines[index] = MedicineModel(
        id: currentMed.id,
        categoryId: currentMed.categoryId,
        commercialName: currentMed.commercialName,
        scientificName: currentMed.scientificName,
        price: currentMed.price,
        isImported: currentMed.isImported,
        availableQuantity: newQuantity < 0 ? 0 : newQuantity, // تجنب القيم السالبة
        barcode: currentMed.barcode,
        images: currentMed.images,
        gift: currentMed.gift,
      );

      // تحديث القائمة ليراقبها Obx
      medicines.refresh();
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    scrollController.dispose();
    categoryScrollController.dispose();
    super.onClose();
  }
}