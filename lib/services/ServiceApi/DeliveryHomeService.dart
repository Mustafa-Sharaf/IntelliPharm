import '../ApiService.dart';

class DeliveryHomeService {
  static Future<Map<String, dynamic>> getDeliveryHome() async {
    final response = await ApiService.get(
      "/planner/v1/deliveries/delivery-home",
    );
    return response.data;
  }
}