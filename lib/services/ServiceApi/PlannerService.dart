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

  /// جلب تفاصيل مسار معين بواسطة الـ ID
  static Future<dynamic> getPlanById(int planId) async {
    final response = await ApiService.get("/planner/v1/plans/$planId");
    return response.data;
  }
}