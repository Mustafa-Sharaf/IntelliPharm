
import '../../modules/ShowOrder/ShowOrder_Model.dart';
import '../../services/ApiService.dart';


class OrderDetailsService {
  static Future<OrderDetailsModel> getOrderDetails(int id) async {
    final response = await ApiService.get('/erp/v1/orders/$id');

    return OrderDetailsModel.fromJson(response.data['data']);
  }
}