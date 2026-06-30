
import 'package:get/get.dart';
import '../../helper/mapHelper/dart/LocationHelperService.dart';
import '../../services/ServiceApi/PharmacyDetailsService.dart';
import 'PharmacyDetails_Model.dart';

class PharmacyDetailsController extends GetxController {
  late final int pharmacyId;
  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = "".obs;
  var pharmacyData = Rxn<PharmacyDetailsModel>();
  var actualAddress = "Retrieving the actual address...".obs;
  var selectedFilter = "ALL".obs;


  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is int) {
      pharmacyId = Get.arguments;
    } else if (Get.arguments is Map && Get.arguments['id'] != null) {
      pharmacyId = Get.arguments['id'];
    } else {
      pharmacyId = int.tryParse(Get.arguments.toString()) ?? 0;
    }

    fetchPharmacyDetails();
  }

  Future<void> fetchPharmacyDetails() async {
    try {
      isLoading(true);
      isError(false);
      final data = await PharmacyDetailsService.getPharmacyDetails(pharmacyId);
      pharmacyData.value = data;

      if (data.latitude != 0.0) {
        actualAddress.value = await LocationHelperService.getAddressFromCoordinates(
          data.latitude,
          data.longitude,
        );
      } else {
        actualAddress.value = "Coordinates are not available for this pharmacy.";
      }
    } catch (e) {
      isError(true);
      errorMessage.value = e.toString().replaceAll("Exception:", "");
    } finally {
      isLoading(false);
    }
  }

  void changeFilter(String filterType) {
    selectedFilter.value = filterType.toUpperCase();
  }

  List<HistoryNote> get filteredNotes {
    if (pharmacyData.value == null) return [];

    if (selectedFilter.value == "ALL") {
      return pharmacyData.value!.historyNotes;
    }

    return pharmacyData.value!.historyNotes
        .where((note) => note.noteType.toUpperCase() == selectedFilter.value)
        .toList();
  }
}