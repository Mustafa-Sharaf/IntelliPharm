
import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String handle(dynamic e) {
    if (e is DioException) {
      var response = e.response;

      if (response != null) {
        var data = response.data;

        String message = data["message"] ?? "Error";

        if (data["errors"] != null) {
          var errors = data["errors"] as Map<String, dynamic>;

          String allErrors = "";
          errors.forEach((key, value) {
            allErrors += "${value[0]}\n";
          });

          return allErrors;
        }

        return message;
      }
      return "Server error";
    }

    return "Unexpected error";
  }
}