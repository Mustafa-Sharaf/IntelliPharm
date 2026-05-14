

import '../../modules/MyOrders/MyOrders_Model.dart';
import '../../services/ApiService.dart';

class OrderFetchService {
  static Future<List<OrderModel>> getOrders() async {
    final response = await ApiService.get('/erp/v1/orders');

    final List data = response.data['data']['data'];

    return data.map((e) => OrderModel.fromJson(e)).toList();
  }
}