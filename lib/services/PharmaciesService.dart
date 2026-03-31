
import '../modules/Pharmacists/Pharmacists_Model.dart';
import 'ApiService.dart';

class PharmacyService {
  static Future<List<PharmaciesModel>> getPharmacies(String region) async {
    final response = await ApiService.get(
      "/erp/v1/pharmacies",
      query: {"region ": region},
    );

    if (response.data["isSuccess"] == true) {
      List data = response.data["data"]["data"];

      return data.map((e) => PharmaciesModel.fromJson(e)).toList();
    } else {
      throw Exception(response.data["message"]);
    }
  }
}