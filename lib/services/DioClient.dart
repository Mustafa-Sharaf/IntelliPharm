
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

          if (statusCode == 403) {
            print("403 Forbidden: User doesn't have permission for this resource.");
            return handler.next(err);
          }

          if (statusCode == 401) {

            if (err.requestOptions.extra["isRetry"] == true) {
              print("Critical: Retry request failed again with 401. Logging out...");
              _logout();
              return handler.next(err);
            }

            try {
              print("Token expired → refreshing...");

              final newToken = await _tokenService.refreshToken();

              if (newToken != null) {
                print("New token received");

                final requestOptions = err.requestOptions;
                requestOptions.headers["Authorization"] = "Bearer $newToken";

                requestOptions.extra["isRetry"] = true;

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
 /*   dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: false,
    ));
*/
  }


/*  static void _logout() {
    print("Refresh failed → logout");
    if (Get.currentRoute != '/signIn') {
      GetStorage().remove("token");
      GetStorage().remove("refresh_token");
      Get.offAllNamed("/signIn");
    }}*/

  static void _logout() {
    print("Refresh failed → logging out...");

    // مسح التوكنات فوراً من الـ Storage لحماية البيانات
    GetStorage().remove("token");
    GetStorage().remove("refresh_token");

    // تأخير عملية الملاحة لضمان أن سياق التطبيق (GetMaterialApp) جاهز تماماً للملاحة Contextless
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.currentRoute != '/signIn') {
        Get.offAllNamed("/signIn");
      }
    });
  }
}