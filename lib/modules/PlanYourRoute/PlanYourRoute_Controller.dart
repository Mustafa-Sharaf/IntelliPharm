import 'package:get/get.dart';

import '../../Widgets/RegionSelector/RegionSelector_Model.dart';
import '../../modules/Pharmacists/Pharmacists_Model.dart';
import '../../services/ServiceApi/PharmaciesService.dart';

class PlanYourRouteController extends GetxController {

  var selectedRegion = Rxn<RegionModel>();

  var pharmacies = <PharmaciesModel>[].obs;

  var selectedPharmacies = <int>{}.obs;

  var isLoading = false.obs;

  var searchQuery = ''.obs;

  Future<void> fetchPharmacies(int regionId) async {

    try {

      isLoading.value = true;

      final result =
      await PharmacyService.getPharmacies(regionId);

      pharmacies.value = result;

    } catch (e) {

      Get.snackbar(
        "Error",
        e.toString(),
      );

    } finally {

      isLoading.value = false;
    }
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
      selectedPharmacies.removeAll(allIds); // deselect all
    } else {
      selectedPharmacies.addAll(allIds); // select all
    }
  }
  bool get isAllSelected {
    final allIds = filteredPharmacies.map((e) => e.id).toSet();
    return selectedPharmacies.containsAll(allIds) && allIds.isNotEmpty;
  }
}