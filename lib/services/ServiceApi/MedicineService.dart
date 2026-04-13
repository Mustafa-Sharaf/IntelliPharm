import '../ApiService.dart';

class MedicineService {
  /// Search Medicines
  static Future getMedicines({
    required int page,
    String query = "",
  }) async {
    final response = await ApiService.get(
      "/erp/v1/medicines",
      query: {
        "page_number": page,
        "per_page": 15,
        "name_starts_with": query,
      },
    );

    return response.data;
  }
}