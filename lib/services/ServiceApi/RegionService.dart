
import '../../Widgets/RegionSelector/RegionSelector_Model.dart';
import '../ApiService.dart';

class RegionService {

  static List<RegionModel>? _cachedRegions;

  static DateTime? _lastFetchTime;


  static const Duration cacheDuration = Duration(hours: 1);

  static Future<List<RegionModel>> getRegions({
    bool forceRefresh = false,
  }) async {

    final now = DateTime.now();

    final isCacheValid =
        _cachedRegions != null &&
            _lastFetchTime != null &&
            now.difference(_lastFetchTime!) < cacheDuration;


    if (isCacheValid && !forceRefresh) {
      return _cachedRegions!;
    }


    final response = await ApiService.get("/erp/v1/regions");

    final data = response.data;

    if (data["isSuccess"] == true) {

      final List list = data["data"]["data"];

      _cachedRegions =
          list.map((e) => RegionModel.fromJson(e)).toList();

      _lastFetchTime = now;

      return _cachedRegions!;

    } else {
      throw Exception(data["message"]);
    }
  }

  static void clearCache() {
    _cachedRegions = null;
    _lastFetchTime = null;
  }
}