import '../../modules/Tracking/TrackingPingRequest.dart';
import '../ApiService.dart';


class TrackingService {
  /// إرسال إحداثيات الموقع الحالية والمعلومات المرافقة للسيرفر
  static Future<bool> sendPing(TrackingPingRequest requestData) async {
    try {
      // استدعاء API الـ Ping عبر كلاس ApiService الموحد لديك
      final response = await ApiService.post(
        "/tracking/v1/ping",
        data: requestData.toJson(),
      );

      // الـ Status Code 204 No Content أو 200 تعني أن الطلب تمت معالجته بنجاح
      if (response.statusCode == 204 || response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      // طباعة الخطأ لتتبع الأخطاء أثناء التطوير دون أن يتأثر استخدام التطبيق
      print("Error in TrackingService (sendPing): $e");
      return false;
    }
  }
}