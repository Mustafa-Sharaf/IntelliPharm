import '../ApiService.dart';

class PlannerService {
  /// بدء/إنشاء المسار المثالي
  static Future<dynamic> initiatePlan({
    required double longitude,
    required double latitude,
    required String reason,
    required String reasonDetails,
    required int regionId,
    required List<int> pharmacyIds,
    required String profile,
    required String travelMode,
    //String? planDate,
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
        //"plan_date": planDate ?? DateTime.now().toIso8601String().split('T').first,
      },
    );

    return response.data;
  }

  /// جلب تفاصيل مسار معين بواسطة الـ ID
  static Future<dynamic> getPlanById(int planId) async {
    final response = await ApiService.get("/planner/v1/plans/$planId");
    return response.data;
  }

  static Future<Map<String, dynamic>?> rePlanRoute({
    required int planId,
    required double latitude,
    required double longitude,
    required String reason,
    required String reasonDetails,
    //String? planDate,
  }) async {
    final response = await ApiService.post(
      "/planner/v1/plans/$planId/optimize-next-leg",
      data: {
        "current_latitude": latitude,
        "current_longitude": longitude,
        "reason": reason,
        "reason_details": reasonDetails,
        //"plan_date": planDate ?? DateTime.now().toIso8601String().split('T').first,
      },
    );
    return response.data;
  }


}