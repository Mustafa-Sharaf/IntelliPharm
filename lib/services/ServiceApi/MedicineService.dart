

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
