

import '../modules/AddPharmacy/AddPharmacy_Model.dart';
import 'ApiService.dart';

class PharmacyService {
  static Future createPharmacy(PharmacyModel request) async {
    final response = await ApiService.post(
      "/erp/v1/pharmacies",
      data: request.toJson(),
    );

    return response.data;
  }
}