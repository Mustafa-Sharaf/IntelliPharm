/*
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
}*/

import '../ApiService.dart';

class MedicineService {
  static Future getMedicines({
    required int page,
    String? query,
    int? categoryId,
  }) async {
    final Map<String, dynamic> queryParams = {
      "page_number": page,
      "per_page": 15,
    };

    if (query != null && query.isNotEmpty) {
      queryParams["name"] = query;
    }

    if (categoryId != null) {
      queryParams["category"] = categoryId;
    }

    final response = await ApiService.get(
      "/erp/v1/medicines",
      query: queryParams,
    );

    return response.data;
  }

  static Future<Map<String, dynamic>> getMedicineDetails(int id) async {
    final response = await ApiService.get('/erp/v1/medicines/$id');
    return response.data;
  }
}
