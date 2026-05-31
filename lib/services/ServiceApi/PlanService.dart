import '../../modules/ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Model.dart';
import '../ApiService.dart';


class PlanService {

  static Future<PlanResponse> createPlan({
    required double currentLat,
    required double currentLng,
    required int regionId,
    required List<int> pharmacyIds,
  }) async {

    final response = await ApiService.post(
      "/planner/v1/plans/initiate",
      data: {
        "current_longitude": currentLng,
        "current_latitude": currentLat,
        "reason": "initiated",
        "reason_details": "starting today's trip",

        // من memory عندك
        "rep_id": null,
        "profile": "vip_first",
        "travel_mode": "walking",

        "region_id": regionId,
        "pharmacy_ids": pharmacyIds,
      },
    );

    if (response.data["isSuccess"] == true) {
      return PlanResponse.fromJson(response.data["data"]);
    }

    throw Exception(response.data["message"]);
  }
}