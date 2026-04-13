import 'dart:async';
import 'package:get/get.dart';

import '../../services/ServiceApi/MedicineService.dart';
import 'AddOrder_Model.dart';


class AddOrderController extends GetxController {
  /// 🔍 البحث
  RxString searchQuery = ''.obs;

  /// 📦 البيانات
  RxList<MedicineModel> medicines = <MedicineModel>[].obs;

  /// ⏳ حالات
  RxBool isLoading = false.obs;
  RxBool isPaginationLoading = false.obs;

  /// 📄 Pagination
  int currentPage = 1;
  int lastPage = 1;

  /// debounce
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchMedicines();
  }

  /// 🔄 جلب البيانات
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
        //query: searchQuery.value,
        query: searchQuery.value.isEmpty ? '' : searchQuery.value,
      );

      final data = response['data'];

      final List list = data['data'];

      final fetchedMedicines =
      list.map((e) => MedicineModel.fromJson(e)).toList();

      /// 📄 pagination info
      lastPage = data['meta']['last_page'];

      if (isLoadMore) {
        medicines.addAll(fetchedMedicines);
      } else {
        medicines.value = fetchedMedicines;
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
    }
  }

  /// 🔍 البحث مع debounce
  void onSearchChanged(String value) {
    searchQuery.value = value;

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchMedicines();
    });
  }

  /// 📄 تحميل المزيد
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