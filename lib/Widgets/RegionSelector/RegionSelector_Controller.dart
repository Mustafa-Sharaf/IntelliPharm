
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../services/ServiceApi/RegionService.dart';
import 'RegionSelector_Model.dart';
class RegionController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  var regions = <RegionModel>[].obs;
  var filteredRegions = <RegionModel>[].obs;

  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMore = true.obs;

  int currentPage = 1;
  int lastPage = 1;

  @override
  void onInit() {
    super.onInit();
    fetchRegions();

    scrollController.addListener(() {
      // التأكد من الوصول لأسفل القائمة مع عدم وجود عملية تحميل حالية وتوفر صفحات إضافية
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100 &&
          !isLoadingMore.value &&
          hasMore.value &&
          searchController.text.isEmpty) {
        fetchMoreRegions();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchRegions() async {
    try {
      isLoading.value = true;
      currentPage = 1;

      final result = await RegionService.getRegions(pageNumber: currentPage);
      final List<RegionModel> fetchedData = result["regions"];
      lastPage = result["lastPage"];

      hasMore.value = currentPage < lastPage;

      regions.assignAll(fetchedData);
      filteredRegions.assignAll(fetchedData);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMoreRegions() async {
    if (currentPage >= lastPage) {
      hasMore.value = false;
      return;
    }

    try {
      isLoadingMore.value = true;
      currentPage++;

      final result = await RegionService.getRegions(pageNumber: currentPage);
      final List<RegionModel> fetchedData = result["regions"];
      lastPage = result["lastPage"];

      hasMore.value = currentPage < lastPage;

      regions.addAll(fetchedData);
      filteredRegions.addAll(fetchedData);
    } catch (e) {
      currentPage--; // إعادة الرقم للصفحة السابقة في حال حدوث خطأ
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  void filter(String value) {
    if (value.isEmpty) {
      filteredRegions.assignAll(regions);
    } else {
      filteredRegions.assignAll(
        regions.where((region) =>
            region.name.toLowerCase().contains(value.toLowerCase())).toList(),
      );
    }
  }

  void selectRegion(RegionModel region) {
    Get.back(result: region);
  }
}