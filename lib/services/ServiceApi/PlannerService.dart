import '../ApiService.dart';

class PlannerService {
  static Future<dynamic> initiatePlan({
    required double longitude,
    required double latitude,
    required String reason,
    required String reasonDetails,
    required int regionId,
    required List<int> pharmacyIds,
    required String profile,
    required String travelMode,
  }) async {
    final response = await ApiService.post(
      "/planner/v1/plans/initiate",
      data: {
        "current_longitude": longitude,
        "current_latitude": latitude,
        "reason": reason,
        "reason_details": reasonDetails,
        "rep_id": null,
        "region_id": regionId,
        "pharmacy_ids": pharmacyIds,
        "profile": profile,
        "travel_mode": travelMode,
      },
    );

    return response.data;
  }

  static Future<dynamic> getGenerationStatus(String requestId) async {
    final response = await ApiService.get(
      "/planner/v1/plans/generation-requests/$requestId",
    );
    return response.data;
  }




  static Future<dynamic> getPlanById(int planId) async {
    final response = await ApiService.get("/planner/v1/plans/$planId");
    return response.data;
  }

/*  static Future<Map<String, dynamic>?> rePlanRoute({
    required int planId,
    required double latitude,
    required double longitude,
    required String reason,
    required String reasonDetails,
  }) async {
    final response = await ApiService.post(
      "/planner/v1/plans/$planId/optimize-next-leg",
      data: {
        "current_latitude": latitude,
        "current_longitude": longitude,
        "reason": reason,
        "reason_details": reasonDetails,
      },
    );
    return response.data;
  }*/

  static Future<Map<String, dynamic>?> rePlanRoute({
    required int planId,
    required double latitude,
    required double longitude,
    required String reason,
    required String reasonDetails,
  }) async {
    try {
      final response = await ApiService.post(
        "/planner/v1/plans/$planId/optimize-next-leg",
        data: {
          "current_latitude": latitude,
          "current_longitude": longitude,
          "reason": reason,
          "reason_details": reasonDetails,
        },
      );
      return response.data;
    } catch (e) {
      print("❌ ApiService RePlan Error: $e");
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> getMyTodayPlan() async {
    try {
      final response = await ApiService.get('/planner/v1/plans/my-today');

      // التأكد من تحويل response.data إلى Map بشكل آمن
      if (response.data != null && response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      print("❌ Error fetching today's plan: $e");
      return null;
    }
  }

  static Future<dynamic> getMyDeliveryToday() async {
    final response = await ApiService.get("/planner/v1/plans/my-delivery-today");
    return response.data;
  }


}