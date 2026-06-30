import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/RegionSelector/RegionSelector_Model.dart';
import '../../helper/mapHelper/dart/MapDrawerHelper.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../../modules/Pharmacists/Pharmacists_Model.dart';
import '../../services/ApiService.dart';
import '../../services/ServiceApi/PharmaciesService.dart';
import '../ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Model.dart';
import '../ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Screen.dart';


class PlanYourRouteController extends GetxController {
  final routeMapController = Get.find<MapHelperController>(tag: "route");
  var selectedRegion = Rxn<RegionModel>();
  var pharmacies = <PharmaciesModel>[].obs;
  var selectedPharmacies = <int>{}.obs;
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var searchQuery = ''.obs;
  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var hasMore = true.obs;
  var selectedType = ''.obs;
  final ScrollController scrollController = ScrollController();
  final String profile = "vip_first";

  String get travelMode => selectedType.value.contains("Walking")
      ? "walking"
      : selectedType.value.contains("Driving")
      ? "driving"
      : "";

  var plan = Rxn<PlanResponse>();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (hasMore.value &&
          !isMoreLoading.value &&
          selectedRegion.value != null) {
        fetchPharmacies(selectedRegion.value!.id, loadMore: true);
      }
    }
  }

  void updateRegion(RegionModel? region) {
    selectedRegion.value = region;
    selectedPharmacies.clear();
    if (region != null) {
      fetchPharmacies(region.id);
    } else {
      pharmacies.clear();
    }
  }

  Future<void> fetchPharmacies(int regionId, {bool loadMore = false}) async {
    try {
      if (loadMore) {
        isMoreLoading.value = true;
      } else {
        isLoading.value = true;
        pharmacies.clear();
        currentPage.value = 1;
      }
      final result = await PharmaciesService.getPharmacies(
        regionId,
        currentPage.value,
      );
      pharmacies.addAll(result.pharmacies);
      lastPage.value = result.lastPage;
      hasMore.value = currentPage.value < lastPage.value;
      currentPage.value++;
    } catch (e) {
      _showErrorSnackbar("حدث خطأ أثناء جلب الصيدليات، يرجى المحاولة لاحقاً");
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> refreshPharmacies() async {
    if (selectedRegion.value == null) return;
    currentPage.value = 1;
    pharmacies.clear();
    hasMore.value = true;
    await fetchPharmacies(selectedRegion.value!.id);
  }

  void togglePharmacy(int id) {
    if (selectedPharmacies.contains(id)) {
      selectedPharmacies.remove(id);
    } else {
      selectedPharmacies.add(id);
    }
  }

  void setSearch(String value) {
    searchQuery.value = value;
  }

  List<PharmaciesModel> get filteredPharmacies {
    if (searchQuery.value.isEmpty) {
      return pharmacies;
    }
    return pharmacies.where((pharmacy) {
      final name = pharmacy.name.toLowerCase();
      final region = pharmacy.region.toLowerCase();
      final query = searchQuery.value.toLowerCase();
      return name.contains(query) || region.contains(query);
    }).toList();
  }

  void toggleSelectAll() {
    final allIds = filteredPharmacies.map((e) => e.id).toSet();
    if (selectedPharmacies.containsAll(allIds)) {
      selectedPharmacies.removeAll(allIds);
    } else {
      selectedPharmacies.addAll(allIds);
    }
  }

  bool get isAllSelected {
    final allIds = filteredPharmacies.map((e) => e.id).toSet();
    return selectedPharmacies.containsAll(allIds) && allIds.isNotEmpty;
  }

  Future<void> initiatePlan() async {
    try {
      if (selectedType.value.isEmpty) {
        _showErrorSnackbar("يرجى اختيار طريقة التنقل أولاً");
        return;
      }
      if (selectedRegion.value == null) {
        _showErrorSnackbar("يرجى اختيار المنطقة أولاً");
        return;
      }
      if (selectedPharmacies.isEmpty) {
        _showErrorSnackbar("يرجى تحديد صيدلية واحدة على الأقل");
        return;
      }

      isLoading.value = true;
      routeMapController.moveToCurrentLocation();

      final response = await ApiService.post(
        "/planner/v1/plans/initiate",
        data: {
          "current_longitude": routeMapController.longitude.value,
          "current_latitude": routeMapController.latitude.value,
          "reason": "initiated",
          "reason_details": "starting today's trip",
          "rep_id": null,
          "region_id": selectedRegion.value!.id,
          "pharmacy_ids": selectedPharmacies.toList(),
          "profile": profile,
          "travel_mode": travelMode,
        },
      );

      if (response.data['isSuccess']) {
        plan.value = PlanResponse.fromJson(response.data['data']);

        await MapDrawerHelper.drawFullRoute(
          routeMapController: routeMapController,
          plan: plan.value,
        );

        Get.to(() => ActiveOptimizedRouteTrackingScreen());
      } else {
        _showErrorSnackbar(response.data['message'] ?? "فشل إنشاء المسار، يرجى المحاولة لاحقاً");
      }
    } catch (e) {
      print("Error initiating plan: $e");
      _showErrorSnackbar("عذراً، حدث خطأ غير متوقع أثناء إعداد المسار");
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      "تنبيه",
      message,
      backgroundColor: Colors.redAccent.shade400,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
