import '../ApiService.dart';

class HomeService {
  static Future getHomePage() async {
    final response = await ApiService.get(
      "/erp/v1/employees/homepage",
    );
    return response.data;
  }
}