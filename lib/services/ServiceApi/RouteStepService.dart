import '../ApiService.dart';

class RouteStepService {
  /// API 1: Start Visit
  static Future<dynamic> startVisit(int visitId) async {
    final response = await ApiService.post(
      "/planner/v1/visits/$visitId/start",
    );
    return response.data;
  }

  /// API 2: Update Visit Status
  static Future<dynamic> updateVisitStatus({
    required int visitId,
    required String status,
    required String cause,
    String? notes,
  }) async {
    final Map<String, dynamic> body = {
      "status": status,
      "driver_reported_cause": cause,
    };

    if (notes != null && notes.isNotEmpty) {
      body["notes"] = notes;
    }

    final response = await ApiService.post(
      "/planner/v1/visits/$visitId/status",
      data: body,
    );
    return response.data;
  }
}