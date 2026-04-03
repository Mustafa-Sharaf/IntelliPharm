


import 'package:get/get.dart';
import '../../Widgets/RegionSelector/RegionSelector_Model.dart';
import '../../services/ServiceApi/PharmaciesService.dart';

import 'Pharmacists_Model.dart';

class PharmacistsController extends GetxController{
  var selectedRegion = Rxn<RegionModel>();

  var pharmacies = <PharmaciesModel>[].obs;
  var isLoading = false.obs;


  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchPharmacies() async {
    if (selectedRegion.value == null) return;

    try {
      isLoading.value = true;

      final data = await PharmacyService.getPharmacies(
        selectedRegion.value!.id,
      );

      pharmacies.value = data;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }



}