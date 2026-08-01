import '../ApiService.dart';

class OrderCancelService {
  static Future<bool> cancelOrder(int orderId) async {
    try {
      final response = await ApiService.patch(
        "/erp/v1/orders/$orderId/cancel",
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      rethrow;
    }
  }
}