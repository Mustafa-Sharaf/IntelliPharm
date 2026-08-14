import 'dart:convert';
import '../../modules/MedicineDetails/MedicineDetails_Model.dart';
import '../../services/ApiService.dart';


class MedicineDetailsService {
  static Future<MedicineDetailsResponse?> fetchMedicineDetails(int medicineId) async {
    try {
      final response = await ApiService.get('/erp/v1/medicines/$medicineId');

      if (response.statusCode == 200 && response.data != null) {
        var rawData = response.data;
        if (rawData is String) {
          rawData = jsonDecode(rawData);
        }

        return MedicineDetailsResponse.fromJson(rawData);
      }
    } catch (e, stackTrace) {
      print("Error fetching medicine details: $e");
      print("StackTrace: $stackTrace");
    }
    return null;
  }
}