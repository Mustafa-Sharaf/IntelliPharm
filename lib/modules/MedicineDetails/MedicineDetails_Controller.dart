import 'package:get/get.dart';
import '../../services/ServiceApi/MedicineDetailsService.dart';
import 'MedicineDetails_Model.dart';

class MedicineDetailsController extends GetxController {
  var isLoading = true.obs;
  var medicineData = Rxn<MedicineDetailsData>();

  @override
  void onInit() {
    super.onInit();
    final int medicineId = Get.arguments as int? ?? 1;
    getMedicineDetails(medicineId);
  }

  Future<void> getMedicineDetails(int medicineId) async {
    try {
      isLoading.value = true;
      final response = await MedicineDetailsService.fetchMedicineDetails(
        medicineId,
      );
      if (response != null && response.isSuccess && response.data != null) {
        medicineData.value = response.data;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
