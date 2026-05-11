import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/ApiService.dart';
import 'PharmacySelector_Model.dart';

class PharmacySelectorController extends GetxController {
  TextEditingController searchController = TextEditingController();

  RxBool isLoading = false.obs;

  RxList<PharmacyModel> pharmacies = <PharmacyModel>[].obs;
  RxList<PharmacyModel> filteredPharmacies = <PharmacyModel>[].obs;

  Rxn<PharmacyModel> selectedPharmacy = Rxn<PharmacyModel>();

  @override
  void onInit() {
    super.onInit();
    fetchPharmacies();
  }

  Future<void> fetchPharmacies() async {
    try {
      isLoading.value = true;

      final response = await ApiService.get('/erp/v1/pharmacies');

      final List pharmaciesJson = response.data['data']['data'];

      pharmacies.value = pharmaciesJson
          .map((e) => PharmacyModel.fromJson(e))
          .toList();

      filteredPharmacies.assignAll(pharmacies);
    } catch (e) {
      print("Error fetching pharmacies: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filter(String query) {
    if (query.isEmpty) {
      filteredPharmacies.assignAll(pharmacies);
      return;
    }

    filteredPharmacies.assignAll(
      pharmacies.where(
        (pharmacy) =>
            pharmacy.name.toLowerCase().contains(query.toLowerCase()) ||
            pharmacy.region.toLowerCase().contains(query.toLowerCase()),
      ),
    );
  }

  void selectPharmacy(PharmacyModel pharmacy) {
    selectedPharmacy.value = pharmacy;
    Get.back();
  }
}
