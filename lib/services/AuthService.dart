import 'package:get_storage/get_storage.dart';

import 'ApiService.dart';
import 'DioClient.dart';

class AuthService {
  static Future login({
    required String email,
    required String password,
    required String deviceToken,
  }) async {
    return await DioClient.dio.post(
      "/auth/v1/login",
      data: {
        "email": email,
        "password": password,
        "FCMToken": deviceToken,
      },
    );
  }

  static Future logout() async {
    final box = GetStorage();
    final refreshToken = box.read<String>('refresh_token');

    return await ApiService.post(
      "/auth/v1/logout",
      data: {
        "refresh_token": refreshToken ?? "",
      },
    );
  }
}