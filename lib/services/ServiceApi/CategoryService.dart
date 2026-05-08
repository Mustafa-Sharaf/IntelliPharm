
import '../ApiService.dart';

class CategoryService {
  static Future getCategories({required int page}) async {
    final response = await ApiService.get(
      "/erp/v1/categories",
      query: {
        "page_number": page,
        "per_page": 15,
      },
    );

    return response.data;
  }
}