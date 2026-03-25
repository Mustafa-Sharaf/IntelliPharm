import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class TokenService {
  final Dio _dio = Dio();

  bool _isRefreshing = false;
  Future<String?>? _refreshFuture;

  Future<String?> refreshToken() async {
    if (_isRefreshing) {
      return _refreshFuture;
    }

    _isRefreshing = true;

    _refreshFuture = _performRefresh();

    final token = await _refreshFuture;

    _isRefreshing = false;

    return token;
  }

  Future<String?> _performRefresh() async {
    try {
      final box = GetStorage();
      final token = box.read<String>("token");

      print("🔄 Sending refresh request...");

      final response = await _dio.post(
        "https://api.intelli-pharma.limebyte.org/api/auth/v2/refresh",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.data["isSuccess"] == true) {
        String newToken = response.data["data"]["access_token"];

        print("✅ Refresh success");

        box.write("token", newToken);

        return newToken;
      }
    } catch (e) {
      print("💥 Refresh error: $e");
    }

    return null;
  }
}