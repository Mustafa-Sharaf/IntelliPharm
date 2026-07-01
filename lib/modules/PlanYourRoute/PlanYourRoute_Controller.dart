import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/AppSnackBar.dart';
import '../../Widgets/PharmacyRouteDialog.dart';
import '../../Widgets/RegionSelector/RegionSelector_Model.dart';
import '../../helper/mapHelper/dart/MapDrawerHelper.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../../modules/Pharmacists/Pharmacists_Model.dart';
import '../../services/ApiService.dart';
import '../../services/ServiceApi/PharmaciesService.dart';
import '../ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Model.dart';
import '../ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Screen.dart';
import '../PharmacyDetails/PharmacyDetails_Model.dart';

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
  String get travelMode => selectedType.value.contains("Walking") ? "walking"
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
      AppSnackBar.error("An error occurred while retrieving the pharmacy items,\n please try again later.");
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


  Future<void> initiatePlan({PharmacyDetailsModel? singlePharmacy}) async {
    try {
      if (selectedType.value.isEmpty) {
        AppSnackBar.error("Please select your travel mode first.");
        return;
      }
      if (selectedRegion.value == null) {
        AppSnackBar.error("Please select your region first.");
        return;
      }
      if (selectedPharmacies.isEmpty) {
        AppSnackBar.error("Please select at least one pharmacy");
        return;
      }
      isLoading.value = true;
      final isSingle = singlePharmacy != null;
      final currentMapController = isSingle
          ? Get.put(MapHelperController(), tag: "mini_route_visit")
          : routeMapController;

      await currentMapController.moveToCurrentLocation();
      await Future.delayed(const Duration(milliseconds: 500));

      final List<int> idsToSend = isSingle ? [singlePharmacy.id] : selectedPharmacies.toList();
      final int regionIdToSend = isSingle ? singlePharmacy.regionId : selectedRegion.value!.id;

      final response = await ApiService.post(
        "/planner/v1/plans/initiate",
        data: {
          "current_longitude": currentMapController.longitude.value,
          "current_latitude": currentMapController.latitude.value,
          "reason": "initiated",
          "reason_details": isSingle ? "preview route for ${singlePharmacy.nameEn}" : "starting today's trip",
          "rep_id": null,
          "region_id": regionIdToSend,
          "pharmacy_ids": idsToSend,
          "profile": profile,
          "travel_mode": travelMode,
        },
      );

      if (response.data['isSuccess']) {
        final planResult = PlanResponse.fromJson(response.data['data']);
          if (isSingle) {
            Get.dialog(
              PharmacyRouteDialog(pharmacy: singlePharmacy, initialPlan: planResult),
              barrierDismissible: true,
            );
          } else {
            plan.value = planResult;
            await MapDrawerHelper.drawFullRoute(
              routeMapController: routeMapController,
              plan: plan.value,
            );
            AppSnackBar.success("The path was successfully created");
            Get.to(() => ActiveOptimizedRouteTrackingScreen());
          }

      } else {
        AppSnackBar.error("Route creation failed, please try again later.");
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        print("SERVER REJECTION DETAILS: ${e.response?.data}");
      } else {
        print("ERROR: $e");
      }
      AppSnackBar.error("Sorry, an unexpected error occurred while setting up the track.");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchCurrentPlan() async {
    if (plan.value == null) return;
    try {
      final response = await ApiService.get("/planner/v1/plans/${plan.value!.id}");

      if (response.data['isSuccess']) {

        plan.value = PlanResponse.fromJson(response.data['data']);

        await MapDrawerHelper.drawFullRoute(
          routeMapController: routeMapController,
          plan: plan.value,
        );
      }
    } catch (e) {
      print("ERROR REFRESHING CURRENT PLAN: $e");
    }
  }
  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

