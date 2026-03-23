
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../configurations/AuthService.dart';
import 'ApiErrorHandler.dart';
import 'AppSnackBar.dart';
import 'LoginValidator.dart';
import 'SignIn_Model.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;
  final box = GetStorage();

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    /// Validation
    final error = LoginValidator.validate(email, password);
    if (error != null) {
      AppSnackBar.error(error);
      return;
    }

    try {
      isLoading.value = true;

      var response = await AuthService.login(
        email: email,
        password: password,
      );

      var data = response.data;

      if (data["isSuccess"] == true) {
        UserModel user = UserModel.fromJson(data["data"]);

        box.write("token", data["data"]["access_token"]);
        box.write("user", user.name);

        AppSnackBar.success(data["message"]);
        Get.offAllNamed("/homeScreen");
      } else {
        AppSnackBar.error(data["message"]);
      }
    } catch (e) {
      String message = ApiErrorHandler.handle(e);
      AppSnackBar.error(message);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}



/*Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final validator = ValidationContext([
      EmptyFieldsValidation([email, password]),
      EmailValidation(email),
      PasswordValidation(password),
    ]);
    final error = validator.validateAll();
    if (error != null) {
      Get.snackbar(
        "Error",
        error,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      var response = await AuthService.login(email: email, password: password);

      var data = response.data;

      if (data["isSuccess"] == true) {
        UserModel user = UserModel.fromJson(data["data"]);
        if (data["token"] != null) {
          box.write("token", data["data"]["access_token"]);
        }
        box.write("user", user.name);
        Get.offAllNamed("/homeScreen");
      } else {
        Get.snackbar("Error", data["message"]);
      }
    } catch (e) {
      if (e is DioException) {
        var response = e.response;

        if (response != null) {
          var data = response.data;

          /// 🔥 رسالة عامة
          String message = data["message"] ?? "Error";

          /// 🔥 أخطاء مفصلة (email, password)
          if (data["errors"] != null) {
            var errors = data["errors"] as Map<String, dynamic>;

            /// جمع كل الأخطاء في نص واحد
            String allErrors = "";

            errors.forEach((key, value) {
              allErrors += "${value[0]}\n";
            });

            message = allErrors;
          }
          print("message=$message");
          Get.snackbar(
            "Error",
            message,
            backgroundColor: Colors.red[300],
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            "Error",
            "Server error",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Unexpected error",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

      print(e);
    } finally {
      isLoading.value = false;
    }
  }
*/