import '../../modules/PharmacyPaymentHistory/PharmacyPaymentHistory_Model.dart';
import '../../services/ApiService.dart';


class PharmacyPaymentHistoryService {
  static Future<PharmacyDebtDetailsResponse> getDebtDetails(String debtId) async {
    final response = await ApiService.get("/erp/v1/debts/$debtId");

    if (response.data["isSuccess"] == true && response.data["data"] != null) {
      return PharmacyDebtDetailsResponse.fromJson(response.data["data"]);
    } else {
      throw Exception(response.data["message"] ?? "Failed to load debt details");
    }
  }
}