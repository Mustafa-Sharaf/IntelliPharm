
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'PharmacyList_Model.dart';


class PharmacySelectorController extends GetxController {

  TextEditingController searchController = TextEditingController();
  RxList<PharmacyModel> pharmacies = <PharmacyModel>[].obs;
  RxList<PharmacyModel> filteredPharmacies = <PharmacyModel>[].obs;
  Rxn<PharmacyModel> selectedPharmacy = Rxn<PharmacyModel>();

  @override
  void onInit() {
    super.onInit();
    loadPharmacies();
  }

  void loadPharmacies() {
    /// مؤقتاً من JSON
    final data = [
      {
        "id": 359,
        "name": "صيدلية علي اسعد",
        "region": "Saroujaa",
        "latitude": "33.492672",
        "longitude": "36.318062",
        "opening_time": "22:00:00",
        "closing_time": "11:00:00",
      },
      {
        "id": 358,
        "name": "صيدلية هبة فواز",
        "region": "Saroujaa",
        "latitude": "33.481979",
        "longitude": "36.297926",
        "opening_time": "09:00:00",
        "closing_time": "22:00:00",
      },
      {
        "id": 357,
        "name": "Pharmacy",
        "region": "Kafr Souseh",
        "latitude": "33.513800",
        "longitude": "36.276500",
        "opening_time": "08:00:00",
        "closing_time": "16:00:00",
      },
    ];

    pharmacies.value =
        data.map((e) => PharmacyModel.fromJson(e)).toList();

    filteredPharmacies.assignAll(pharmacies);

    if (pharmacies.isNotEmpty) {
      selectedPharmacy.value = pharmacies.first;
    }
  }

  void filter(String query) {
    if (query.isEmpty) {
      filteredPharmacies.assignAll(pharmacies);
    } else {
      filteredPharmacies.assignAll(
        pharmacies.where(
              (pharmacy) =>
          pharmacy.name.toLowerCase().contains(query.toLowerCase()) ||
              pharmacy.region.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  void selectPharmacy(PharmacyModel pharmacy) {
    selectedPharmacy.value = pharmacy;
    Get.back();
  }
}