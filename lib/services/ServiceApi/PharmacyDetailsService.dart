import '../../modules/PharmacyDetails/PharmacyDetails_Model.dart';
import '../ApiService.dart';


class PharmacyDetailsService {
  static Future<PharmacyDetailsModel> getPharmacyDetails(int pharmacyId) async {
    final response = await ApiService.get(
      "/erp/v1/pharmacies/$pharmacyId",
    );

    if (response.data["isSuccess"] == true && response.data["data"] != null) {
      return PharmacyDetailsModel.fromJson(response.data["data"]);
    } else {
      throw Exception(response.data["message"] ?? "Failed to load pharmacy details");
    }
  }
}