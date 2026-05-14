import 'package:get/get.dart';

import '../../Widgets/RegionSelector/RegionSelector_Model.dart';
import '../../modules/Pharmacists/Pharmacists_Model.dart';
import '../../services/ServiceApi/PharmaciesService.dart';

class PlanYourRouteController extends GetxController {

  var selectedRegion = Rxn<RegionModel>();

  var pharmacies = <PharmaciesModel>[].obs;

  var selectedPharmacies = <int>[].obs;

  var isLoading = false.obs;

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
}