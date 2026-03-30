import '../Widgets/RegionSelector/RegionSelector_Model.dart';
import 'ApiService.dart';

class RegionService {
  static Future<List<RegionModel>> getRegions() async {
    final response = await ApiService.get("/erp/v1/regions");

    final data = response.data;

    if (data["isSuccess"] == true) {
      final List list = data["data"]["data"];

      return list.map((e) => RegionModel.fromJson(e)).toList();
    } else {
      throw Exception(data["message"]);
    }
  }
}
