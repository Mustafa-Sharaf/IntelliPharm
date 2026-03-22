
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../configurations/AuthService.dart';
import 'SignIn_Model.dart';


class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;
  final box = GetStorage();


  Future<void> login() async {
    try {
      isLoading.value = true;

      var response = await AuthService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      var data = response.data;

      if (data["isSuccess"] == true) {
        UserModel user = UserModel.fromJson(data["data"]);
        if (data["token"] != null) {
          box.write("token", data["token"]);
        }
        box.write("user", user.name);
        Get.snackbar("Success", data["message"]);
        Get.offAllNamed("/homeScreen");
      } else {
        Get.snackbar(
            "Error",
            data["message"]
        );

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
          print( "message=$message");
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

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}