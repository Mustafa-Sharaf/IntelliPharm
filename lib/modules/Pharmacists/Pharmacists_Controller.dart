import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/RegionSelector/RegionSelector_Model.dart';
import '../../modules/Pharmacists/Pharmacists_Model.dart';
import '../../services/ServiceApi/PharmaciesService.dart';

class PharmacistsController extends GetxController {
  var selectedTab = 0.obs;
  var pharmacies = <PharmaciesModel>[].obs;
  var selectedRegion = Rxn<RegionModel>();
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var searchQuery = "".obs;

  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var hasMore = true.obs;

  var selectedRegionId = RxnInt();
  var selectedRegionName = "".obs;

  final ScrollController scrollController = ScrollController();

  List<String> get tabs {
    final firstTabName = selectedRegionName.value.isNotEmpty
        ? selectedRegionName.value
        : "AllRegions".tr;

    return [firstTabName, "OpenNow".tr, "CloseNow".tr];
  }

  @override
  void onInit() {
    super.onInit();
    fetchPharmacies();
    scrollController.addListener(_onScroll);
  }

  // Scroll Pagination
  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 100) {
      if (hasMore.value && !isMoreLoading.value && !isLoading.value) {
        fetchPharmacies(loadMore: true);
      }
    }
  }

  Future<void> fetchPharmacies({bool loadMore = false}) async {
    try {
      if (loadMore) {
        isMoreLoading.value = true;
      } else {
        isLoading.value = true;
        pharmacies.clear();
        currentPage.value = 1;
        hasMore.value = true;
      }

      final pageToFetch = currentPage.value;

      final result = await PharmaciesService.getPharmacies(
        selectedRegionId.value,
        pageToFetch,
      );

      if (pageToFetch == 1) {
        pharmacies.assignAll(result.pharmacies);
      } else {
        pharmacies.addAll(result.pharmacies);
      }

      lastPage.value = result.lastPage;

      if (pageToFetch >= lastPage.value) {
        hasMore.value = false;
      } else {
        hasMore.value = true;
        currentPage.value++;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  /// 🟢 دالة اختيار المنطقة وإعادة جلب البيانات
  void setRegion(RegionModel? region) {
    if (region == null) {
      selectedRegionId.value = null;
      selectedRegionName.value = "";
    } else {
      selectedRegionId.value = region.id;
      selectedRegionName.value = region.name;
    }

    // 🟢 تصفير الفلترة الميدانية والبحث لضمان رؤية جميع صيدليات المنطقة الجديدة
    selectedTab.value = 0;
    searchQuery.value = "";

    // إعادة جلب الصيدليات للمنطقة المختارة
    fetchPharmacies();
  }

  // Refresh
  Future<void> refreshData() async {
    currentPage.value = 1;
    pharmacies.clear();
    hasMore.value = true;
    await fetchPharmacies();
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  List<PharmaciesModel> get filteredPharmacies {
    final q = searchQuery.value.toLowerCase();

    // 1. Tabs filter (التبويب 0 يعرض جميع صيدليات المنطقة المحددة)
    List<PharmaciesModel> results = pharmacies;

    if (selectedTab.value == 1) {
      results = results.where((p) => p.checkIsOpen).toList();
    } else if (selectedTab.value == 2) {
      results = results.where((p) => !p.checkIsOpen).toList();
    }

    // 2. Search filter
    if (q.isNotEmpty) {
      results = results.where((p) {
        final nameMatch = p.name.toLowerCase().contains(q);
        final pharmacistMatch =
            p.pharmacistName?.toLowerCase().contains(q) ?? false;

        return nameMatch || pharmacistMatch;
      }).toList();
    }

    return results;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}