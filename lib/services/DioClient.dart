
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'TokenService.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://api.intelli-pharma.limebyte.org/api",
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        "Accept": "application/json",
      },
    ),
  );

  static final TokenService _tokenService = TokenService();

  static void init() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = GetStorage().read<String>('token');

          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          options.headers["Accept-Language"] =
              Get.locale?.languageCode ?? "en";

          handler.next(options);
        },

        onError: (DioException err, handler) async {
          final statusCode = err.response?.statusCode;

          print("Error: $statusCode");

          if (statusCode == 401 || statusCode == 403) {
            try {
              print("Token expired → refreshing...");

              final newToken = await _tokenService.refreshToken();

              if (newToken != null) {
                print("New token received");

                final requestOptions = err.requestOptions;

                requestOptions.headers["Authorization"] =
                "Bearer $newToken";

                print("Retrying request...");

                final response = await dio.fetch(requestOptions);

                return handler.resolve(response);
              } else {
                print("Refresh failed → logout");

                _logout();
              }
            } catch (e) {
              print("Refresh exception: $e");

              _logout();
            }
          }

          handler.next(err);
        },
      ),
    );
  }
  static void _logout() {
    final box = GetStorage();
    box.erase();
    Get.offAllNamed("/signIn");
  }
}