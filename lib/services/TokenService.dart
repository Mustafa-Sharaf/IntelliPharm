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
      final refreshToken = box.read<String>("refresh_token");

      if (refreshToken == null) {
        print("No refresh token found");
        return null;
      }

      print("Sending refresh request...");

      final response = await _dio.post(
        "https://api.intelli-pharma.limebyte.org/api/auth/v1/refresh",
        data: {
          "refresh_token": refreshToken,
        },
      );

      // التحقق بناءً على رد السيرفر الذي أرسلته
      if (response.data["isSuccess"] == true) {
        // الـ Tokens موجودة داخل كائن الـ data الداخلي
        String newToken = response.data["data"]["access_token"];
        String newRefresh = response.data["data"]["refresh_token"];

        print("Refresh success. New access token acquired.");

        // حفظ الـ Tokens الجديدة في الـ Storage للاستخدام القادم
        await box.write("token", newToken);
        await box.write("refresh_token", newRefresh);

        return newToken;
      }
    } catch (e) {
      print("Refresh error: $e");
    }

    return null;
  }
}




/* Future<String?> _performRefresh() async {
    try {
      final box = GetStorage();

      final refreshToken = box.read<String>("refresh_token");

      if (refreshToken == null) {
        print("No refresh token found");
        return null;
      }

      print("Sending refresh request...");

      final response = await _dio.post(
        "https://api.intelli-pharma.limebyte.org/api/auth/v1/refresh",
        data: {
          "refresh_token": refreshToken,
        },
      );

      if (response.data["isSuccess"] == true) {
        String newToken = response.data["data"]["access_token"];
        String newRefresh = response.data["data"]["refresh_token"];

        print("Refresh success");

        box.write("token", newToken);
        box.write("refresh_token", newRefresh);

        return newToken;
      }
    } catch (e) {
      print("Refresh error: $e");
    }

    return null;
  }*/
