import '../../modules/Tracking/TrackingPingRequest.dart';
import '../ApiService.dart';

class TrackingService {
  static Future<bool> sendPing(TrackingPingRequest requestData) async {
    try {
      final response = await ApiService.post(
        "/tracking/v1/ping",
        data: requestData.toJson(),
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print("Error in TrackingService (sendPing): $e");
      return false;
    }
  }
}
