import 'package:dio/dio.dart';
import 'DioClient.dart';

class ApiService {
  static Future<Response> get(String url, {Map<String, dynamic>? query}) async {
    return await DioClient.dio.get(url, queryParameters: query);
  }

  static Future<Response> post(String url, {dynamic data}) async {
    return await DioClient.dio.post(url, data: data);
  }

  static Future<Response> delete(String url) async {
    return await DioClient.dio.delete(url);
  }

  static Future<Response> patch(String url, {dynamic data}) async {
    return await DioClient.dio.patch(url, data: data);
  }
}
