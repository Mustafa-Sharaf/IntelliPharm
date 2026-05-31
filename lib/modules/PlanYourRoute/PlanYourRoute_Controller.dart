
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Widgets/RegionSelector/RegionSelector_Model.dart';
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
  late final String travelMode = selectedType.value.contains("Walking")
      ? "walking"
      : "driving";


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
      Get.snackbar("Error", e.toString());
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
      if (travelMode.isEmpty) {
        Get.snackbar("Error", "Please select Travel Mode");
        return;
      }
      if (selectedRegion.value == null) {
        Get.snackbar("Error", "Please select region");
        return;
      }

      if (selectedPharmacies.isEmpty) {
        Get.snackbar("Error", "Please select pharmacies");
        return;

      }
      routeMapController.moveToCurrentLocation();
      isLoading.value = true;
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
        drawRoute();
        Get.to(() =>  ActiveOptimizedRouteTrackingScreen());
      } else {
        Get.snackbar("Error", response.data['message']);
        print("response.data['message']=${response.data['message']}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("Error e.toString(): ${e.toString()}");
      if (e is DioException) {
        print("STATUS: ${e.response?.statusCode}");
        print("DATA: ${e.response?.data}");
      }
    } finally {
      isLoading.value = false;
    }
  }



  void drawRoute() {
    List<List<LatLng>> allPaths = [];

    routeMapController.clearAll();

    for (var path in plan.value!.paths) {
      final decoded = decodePolyline(path.geometry);
      allPaths.add(decoded);
    }
/*    for (var path in plan.value!.paths) {
      final decoded = decodePolyline(path.geometry);

      print("decoded points = ${decoded.length}");

      for (var p in decoded) {
        print("${p.latitude}, ${p.longitude}");
      }

      allPaths.add(decoded);
    }*/

    routeMapController.drawRoutes(allPaths);

    for (var path in plan.value!.paths) {
      final decoded = decodePolyline(path.geometry);

      if (decoded.isNotEmpty) {
        final lastPoint = decoded.last;
        routeMapController.addMarker(position: lastPoint, title: "Visit ${path.to}");
      }
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }




  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
