
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
          final box = GetStorage();

          // 1. التوكن
          final token = box.read<String>('token');
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          // 2. قراءة اللغة المكتوبة حالياً في GetStorage لضمان أحدث قيمة فوراً
          final String currentLang = box.read<String>('lang') ?? 'ar';
          options.headers["Accept-Language"] = currentLang;

          handler.next(options);
        },

        onError: (DioException err, handler) async {
          final statusCode = err.response?.statusCode;
          print("Error: $statusCode");
          if (err.response?.data != null) {
            print("SERVER 403 RESPONSE DETAILS: ${err.response?.data}");
          }

          if (statusCode == 403) {
            return handler.next(err);
          }

          if (statusCode == 401) {
            if (err.requestOptions.extra["isRetry"] == true) {
              _logout();
              return handler.next(err);
            }

            try {
              final newToken = await _tokenService.refreshToken();

              if (newToken != null) {
                final requestOptions = err.requestOptions;
                requestOptions.headers["Authorization"] = "Bearer $newToken";
                requestOptions.extra["isRetry"] = true;

                final response = await dio.fetch(requestOptions);
                return handler.resolve(response);
              } else {
                _logout();
              }
            } catch (e) {
              _logout();
            }
          }

          handler.next(err);
        },

        onResponse: (response, handler) {
          print("========== RESPONSE ==========");
          print("STATUS: ${response.statusCode}");
          print("BODY:");
          print(response.data);
          print("==============================");

          handler.next(response);
        },
      ),
    );
  }

  static void _logout() {
    GetStorage().remove("token");
    GetStorage().remove("refresh_token");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.currentRoute != '/signIn') {
        Get.offAllNamed("/signIn");
      }
    });
  }
}