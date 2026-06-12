
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Widgets/RegionSelector/RegionSelector_Model.dart';
import '../../modules/Pharmacists/Pharmacists_Model.dart';
import '../../services/ServiceApi/PharmaciesService.dart';

class PharmacistsController extends GetxController {
  var selectedTab = 0.obs;
  final tabs = ["All Regions", "Open Now", "Close Now"];

  var pharmacies = <PharmaciesModel>[].obs;
  var selectedRegion = Rxn<RegionModel>();

  var isLoading = false.obs;
  var isMoreLoading = false.obs;

  var searchQuery = "".obs;

  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var hasMore = true.obs;

  final int regionId = 40;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();

    fetchPharmacies();

    scrollController.addListener(_onScroll);
  }


  void openWhatsApp(String phone) async {
    final url = Uri.parse(
      'https://api.whatsapp.com/send?phone=$phone',
    );

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
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


  // Fetch Data
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
        regionId,
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

    // 1. Tabs filter
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


//Mustafa sharaf