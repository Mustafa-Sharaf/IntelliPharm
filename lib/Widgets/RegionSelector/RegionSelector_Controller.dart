
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../services/ServiceApi/RegionService.dart';
import 'RegionSelector_Model.dart';


class RegionController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  var regions = <RegionModel>[].obs;
  var filteredRegions = <RegionModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRegions();
  }

  Future<void> fetchRegions() async {
    try {
      isLoading.value = true;

      final data = await RegionService.getRegions();

      regions.value = data;
      filteredRegions.value = data;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void filter(String value) {
    if (value.isEmpty) {
      filteredRegions.value = regions;
    } else {
      filteredRegions.value = regions
          .where((region) =>
          region.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
  }

  void selectRegion(RegionModel region) {
    //print("Selected: ${region.name}");
    Get.back(result: region);
  }
}