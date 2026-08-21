
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Widgets/AppSnackBar.dart';
import '../../Widgets/PharmacyRouteDialog.dart';
import '../../Widgets/RegionSelector/RegionSelector_Model.dart';
import '../../helper/mapHelper/dart/MapDrawerHelper.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../../modules/Pharmacists/Pharmacists_Model.dart';
import '../../services/ServiceApi/PharmaciesService.dart';
import '../../services/ServiceApi/PlannerService.dart';
import '../ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Model.dart';
import '../PharmacyDetails/PharmacyDetails_Model.dart';
import 'ReverbService.dart';

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
  var selectedProfileKey = RxnString();

  Timer? _pollingTimer;
  String? _currentRequestId;
  String? _currentChannel;

  final Map<String, String> profileApiValues = {
    "Fastest": "fastest",
    "Cheapest": "cheapest",
    "VIP First": "vip_first",
    "Priority": "priority_first",
    "Balanced": "balanced",
    "All Factors": "all_factors",
  };

  final Map<String, String> profileSubtitles = {
    "Fastest": "Fastest available route for now",
    "Cheapest": "Route that reduces fuel consumption",
    "VIP First": "Serve the most important pharmacies first",
    "Priority": "Serve the highest priority deliveries first",
    "Balanced": "Middle ground between options",
    "All Factors": "Combination of the options above",
  };

  String get profile => selectedProfileKey.value != null
      ? (profileApiValues[selectedProfileKey.value!] ?? "")
      : "";

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
      AppSnackBar.error(
        "An error occurred while retrieving the pharmacy items,please try again later.".tr,
      );
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
    // 1. التصفية حسب المنطقة المختارة أولاً
    List<PharmaciesModel> regionList = pharmacies;

    if (selectedRegion.value != null) {
      regionList = pharmacies.where((pharmacy) {
        //  مطابقة ID المنطقة (أو اسمها إذا كان النموذج ينقل اسمها فقط)
        return pharmacy.regionId == selectedRegion.value!.id ||
            pharmacy.region.toLowerCase() == selectedRegion.value!.name.toLowerCase();
      }).toList();
    }

    // 2. إذا لم يكن هناك نص بحث، نرجع القائمة المفلترة حسب المنطقة
    if (searchQuery.value.isEmpty) {
      return regionList;
    }

    // 3. التصفية حسب نص البحث من ضمن صيدليات المنطقة المختارة فقط
    final query = searchQuery.value.toLowerCase();
    return regionList.where((pharmacy) {
      final name = pharmacy.name.toLowerCase();
      final region = pharmacy.region.toLowerCase();
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
        AppSnackBar.error("Please select your travel mode first.".tr);
        return;
      }

      if (selectedProfileKey.value == null || profile.isEmpty) {
        AppSnackBar.error("Please_select_route_profile".tr);
        return;
      }

      final isSingle = singlePharmacy != null;

      if (!isSingle) {
        if (selectedRegion.value == null) {
          AppSnackBar.error("Please select your region first.".tr);
          return;
        }

        if (selectedPharmacies.isEmpty) {
          AppSnackBar.error("Please select at least one pharmacy".tr);
          return;
        }
      }

      isLoading.value = true;

      final currentMapController = isSingle
          ? Get.put(MapHelperController(), tag: "mini_route_visit")
          : routeMapController;

      await currentMapController.moveToCurrentLocation();

      final List<int> idsToSend =
      isSingle ? [singlePharmacy.id] : selectedPharmacies.toList();
      final int regionIdToSend =
      isSingle ? singlePharmacy.regionId : selectedRegion.value!.id;

      // 🟢 1. تجهيز بيانات الـ Request
    /*  final requestBody = {
        "latitude": currentMapController.latitude.value,
        "longitude": currentMapController.longitude.value,
        "reason": "initiated",
        "reason_details": isSingle
            ? "preview route for ${singlePharmacy.nameEn}"
            : "starting today's trip",
        "region_id": regionIdToSend,
        "pharmacy_ids": idsToSend,
        "profile": profile,
        "travel_mode": travelMode,
      };*/

     /* print("=========  SENDING PLANNER REQUEST =========");
      print("REQUEST BODY: ${jsonEncode(requestBody)}");
      print("==================================================");*/

      //  3. إرسال الطلب
      final responseData = await PlannerService.initiatePlan(
        longitude: currentMapController.longitude.value,
        latitude: currentMapController.latitude.value,
        reason: "initiated",
        reasonDetails: isSingle
            ? "preview route for ${singlePharmacy.nameEn}"
            : "starting today's trip",
        regionId: regionIdToSend,
        pharmacyIds: idsToSend,
        profile: profile,
        travelMode: travelMode,
      );

      if (responseData != null && responseData['isSuccess'] == true) {
        final queueData = responseData['data'];

        _currentRequestId = queueData['request_id'];
        _currentChannel = queueData['channel'];

       // print("Subscribing to channel: $_currentChannel");

        final readyEvent = queueData['ready_event'] ?? 'plan.ready';
        final failedEvent = queueData['failed_event'] ?? 'plan.failed';

        Get.snackbar(
          "The track is under construction".tr,
          "The optimal route is being calculated, please wait...".tr,
          backgroundColor: Colors.blue.withValues(alpha: 0.8),
          colorText: Colors.white,
        );

        final reverbService = Get.find<ReverbService>();
        await reverbService.subscribe(
          channel: _currentChannel!,
          onEvent: (event, payload) async {
            print("Event received [$event]: $payload");

            final incomingId = payload['request_id'] ?? payload['id'];

            if (incomingId == _currentRequestId) {
              if (event == readyEvent) {
                _stopPlanListening();
                await _handlePlanSuccess(payload['plan'], singlePharmacy);
              } else if (event == failedEvent) {
                _stopPlanListening();
                isLoading.value = false;
                AppSnackBar.error("Failed to generate plan".tr);
              }
            }
          },
        );

        _startPollingFallback(_currentRequestId!, singlePharmacy);
      } else {
        isLoading.value = false;
        AppSnackBar.error("Route creation failed, please try again later.".tr);
      }
    } catch (e) {
      isLoading.value = false;
      print(" Location/Initiate error: $e");

      String errorMsg = e.toString();

      if (errorMsg.contains("GPS_DISABLED")) {
        AppSnackBar.error("Location services (GPS) are disabled. Please enable them in your phone's settings.".tr,);
      } else if (errorMsg.contains("PERMISSION_DENIED")) {
        AppSnackBar.error("Please grant the app access to the location to begin.".tr);
      } else {
        Get.defaultDialog(
          title: "Site update required".tr,
          titleStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          middleText:
          "Your live location".tr,
          textConfirm: "Open Google Maps".tr,
          textCancel: "cancel".tr,
          confirmTextColor: Colors.white,
          buttonColor: const Color(0xFF2196F3),
          onConfirm: () {
            Get.back();
            _openGoogleMapsToFixGps();
          },
        );
      }
    }
  }
  Future<void> _handlePlanSuccess(
      dynamic planJson,
      PharmacyDetailsModel? singlePharmacy,
      ) async {
    isLoading.value = false;
    final planResult = PlanResponse.fromJson(planJson);

    if (singlePharmacy != null) {
      Get.dialog(
        PharmacyRouteDialog(
          pharmacy: singlePharmacy,
          initialPlan: planResult,
        ),
        barrierDismissible: true,
      );
    } else {
      plan.value = planResult;
      await MapDrawerHelper.drawFullRoute(
        routeMapController: routeMapController,
        plan: plan.value,
      );
      AppSnackBar.success("The path was successfully created".tr);
      Get.toNamed("/activeOptimizedRouteTracking");
    }
  }

  void _startPollingFallback(
      String requestId,
      PharmacyDetailsModel? singlePharmacy,
      ) {
    _pollingTimer?.cancel();
    int attempts = 0;
    const maxAttempts = 15;

    _pollingTimer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      attempts++;

      if (attempts > maxAttempts) {
        _stopPlanListening();
        isLoading.value = false;
        AppSnackBar.error("The server took a long time to calculate the path. Please try again later.".tr,);
        return;
      }

      try {
        final res = await PlannerService.getGenerationStatus(requestId);
        if (res != null && res['isSuccess'] == true) {
          final data = res['data'];
          final status = data['status'];

          if (status == 'completed' || status == 'success') {
            _stopPlanListening();
            final planData = data['plan'] ?? data;
            await _handlePlanSuccess(planData, singlePharmacy);
          } else if (status == 'failed') {
            _stopPlanListening();
            isLoading.value = false;
            AppSnackBar.error("Plan creation failed".tr);
          }
        }
      } catch (e) {
        print("Polling check error: $e");
      }
    });
  }

  void _stopPlanListening() {
    _pollingTimer?.cancel();
    if (_currentChannel != null) {
      Get.find<ReverbService>().unsubscribe(_currentChannel!);
    }
  }

  Future<void> fetchCurrentPlan() async {
    if (plan.value == null) return;
    try {
      final responseData = await PlannerService.getPlanById(plan.value!.id);

      if (responseData['isSuccess']) {
        plan.value = PlanResponse.fromJson(responseData['data']);

        await MapDrawerHelper.drawFullRoute(
          routeMapController: routeMapController,
          plan: plan.value,
        );
      }
    } catch (e) {
      print("ERROR REFRESHING CURRENT PLAN: $e");
    }
  }

  void _openGoogleMapsToFixGps() async {
    final Uri googleMapsUri = Uri.parse("https://www.google.com/maps");
    try {
      if (await canLaunchUrl(googleMapsUri)) {
        await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
      } else {
        AppSnackBar.error("The Google Maps app could not be opened automatically.".tr);
      }
    } catch (e) {
      print("Error launching maps: $e");
    }
  }

  @override
  void onClose() {
    _stopPlanListening();
    scrollController.dispose();
    super.onClose();
  }
}