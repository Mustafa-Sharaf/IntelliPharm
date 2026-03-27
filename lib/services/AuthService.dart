
import 'DioClient.dart';

class AuthService {
  static Future login({
    required String email,
    required String password,
  }) async {
    return await DioClient.dio.post(
      "/auth/v1/login",
      data: {
        "email": email,
        "password": password,
      },
    );
  }
}