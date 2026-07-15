import '../../services/ApiService.dart';

class MyDeliveriesService {
  static Future<Map<String, dynamic>> getMyDeliveries({String? status}) async {
    final Map<String, dynamic> queryParams = {};
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    final response = await ApiService.get(
      "/planner/v1/deliveries/my-deliveries",
      query: queryParams,
    );
    return response.data;
  }
}