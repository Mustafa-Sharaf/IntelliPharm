
import '../../services/ApiService.dart';

class OrderService {
  static Future<dynamic> createOrder({
    required int pharmacyId,
    required List<Map<String, dynamic>> items,
    String? notes,
  }) async {
    final response = await ApiService.post(
      '/erp/v1/orders',
      data: {
        "pharmacy_id": pharmacyId,
        "warehouse_id": 1,
        "items": items,
        "notes": notes ?? "",
      },
    );

    return response.data;
  }
}