
import 'dart:async';
import 'package:get/get.dart';

import '../../services/ServiceApi/CategoryService.dart';
import '../../services/ServiceApi/MedicineService.dart';
import 'AddOrder_Model.dart';
import 'CategoryModel.dart';

class AddOrderController extends GetxController {
  /// search text
  RxString searchQuery = ''.obs;

  /// medicines list
  RxList<MedicineModel> medicines = <MedicineModel>[].obs;

  /// categories list
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  /// loading states
  RxBool isLoading = false.obs;
  RxBool isPaginationLoading = false.obs;

  /// pagination
  int currentPage = 1;
  int lastPage = 1;

  /// selected tab
  var selectedTab = 0.obs;

  /// selected category id
  int? selectedCategoryId;

  /// debounce
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchMedicines();
  }

  /// fetch categories
  Future<void> fetchCategories() async {
    try {
      final response = await CategoryService.getCategories(page: 1);

      final List list = response['data']['data'];

      categories.value =
          list.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      print("Categories Error: $e");
    }
  }

  /// change selected category
  void changeTab(int index) {
    selectedTab.value = index;

    selectedCategoryId = categories[index].id;

    fetchMedicines();
  }

  /// fetch medicines
  Future<void> fetchMedicines({bool isLoadMore = false}) async {
    try {
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

      final fetchedMedicines =
      list.map((e) => MedicineModel.fromJson(e)).toList();

      lastPage = data['meta']['last_page'];

      if (isLoadMore) {
        medicines.addAll(fetchedMedicines);
      } else {
        medicines.value = fetchedMedicines;
      }
    } catch (e) {
      print("Medicines Error: $e");
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
    }
  }

  /// search with debounce
  void onSearchChanged(String value) {
    searchQuery.value = value;

    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(
      const Duration(milliseconds: 500),
          () {
        fetchMedicines();
      },
    );
  }

  /// load more pagination
  void loadMore() {
    if (currentPage < lastPage && !isPaginationLoading.value) {
      currentPage++;
      fetchMedicines(isLoadMore: true);
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}