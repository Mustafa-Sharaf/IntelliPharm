
import '../ApiService.dart';

class EditOrderService {
  static Future<bool> updateOrder({
    required int orderId,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final response = await ApiService.put(
        '/erp/v1/orders/$orderId',
        data: {
          "items": items,
        },
      );

      if (response.statusCode == 200 && response.data['isSuccess'] == true) {
        return true;
      }
      return false;
    } catch (e) {
      print("Update order error: $e");
      rethrow;
    }
  }
}