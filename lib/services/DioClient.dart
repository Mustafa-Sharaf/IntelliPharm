
/*
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

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

  static void init() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = GetStorage().read<String>('token');

          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },
      ),
    );
  }
}*/
/*
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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

  static void init() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {

          final token = GetStorage().read<String>('token');

          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          handler.next(options);
        },


        onError: (DioException err, handler) async {
          print("Error response statusCode-------- ${err.response?.statusCode}");
          if (err.response?.statusCode == 401 ||
              err.response?.statusCode == 403) {
            try {
              print("🔄 Token expired → Refreshing...");
              final newToken = await _refreshToken();


              if (newToken != null) {
                print("New Token Received");
                final options = err.requestOptions;

                options.headers["Authorization"] = "Bearer $newToken";
                print("🔁 Retrying original request...");

                final response = await dio.fetch(options);

                return handler.resolve(response);
              }
              else {
                print("❌ Refresh failed → logout");
              }
            } catch (e) {
              print("💥 Exception during refresh: $e");
              GetStorage().remove("token");
              Get.offAllNamed("/login");
            }
          }

          handler.next(err);
        },
      ),
    );
  }


  static Future<String?> _refreshToken() async {
    try {
      final box = GetStorage();
      final token = box.read<String>("token");

      print("Sending refresh request...");
      final response = await Dio().post(
        "https://api.intelli-pharma.limebyte.org/api/auth/v2/refresh",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.data["isSuccess"] == true) {
        String newToken = response.data["data"]["access_token"];
        print("Refresh success--------");
        box.write("token", newToken);

        return newToken;
      }else {
        print("Refresh API returned false-----------");
      }
    } catch (e) {
      print("Refresh error: $e");
      return null;
    }

    return null;
  }
}*/
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

          handler.next(options);
        },

        onError: (DioException err, handler) async {
          final statusCode = err.response?.statusCode;

          print("❌ Error: $statusCode");

          if (statusCode == 401 || statusCode == 403) {
            try {
              print("🔄 Token expired → refreshing...");

              final newToken = await _tokenService.refreshToken();

              if (newToken != null) {
                print("✅ New token received");

                final requestOptions = err.requestOptions;

                requestOptions.headers["Authorization"] =
                "Bearer $newToken";

                print("🔁 Retrying request...");

                final response = await dio.fetch(requestOptions);

                return handler.resolve(response);
              } else {
                print("❌ Refresh failed → logout");

                _logout();
              }
            } catch (e) {
              print("💥 Refresh exception: $e");

              _logout();
            }
          }

          handler.next(err);
        },
      ),
    );
  }

  static void _logout() {
    GetStorage().remove("token");
    Get.offAllNamed("/login");
  }
}