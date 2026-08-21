import '../../Widgets/RegionSelector/RegionSelector_Model.dart';
import '../ApiService.dart';
class RegionService {
  static Future<Map<String, dynamic>> getRegions({
    int pageNumber = 1,
    int perPage = 15,
  }) async {
    final response = await ApiService.get(
      "/erp/v1/regions?per_page=$perPage&page_number=$pageNumber",
    );

    final data = response.data;

    if (data["isSuccess"] == true) {
      final List list = data["data"]["data"];
      final int lastPage = data["data"]["meta"]["last_page"];

      return {
        "regions": list.map((e) => RegionModel.fromJson(e)).toList(),
        "lastPage": lastPage,
      };
    } else {
      throw Exception(data["message"] ?? "Failed to load regions");
    }
  }
}