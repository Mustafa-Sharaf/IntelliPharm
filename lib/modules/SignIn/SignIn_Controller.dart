
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../Widgets/AppSnackBar.dart';
import '../../services/AuthService.dart';
import 'ApiErrorHandler.dart';
import 'LoginValidator.dart';
import 'SignIn_Model.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;
  final box = GetStorage();

  Future<void> login() async {
    String fcmToken = GetStorage().read('fcm_token')??"";
    print("fcmToken= $fcmToken");
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
        deviceToken : fcmToken ,
      );

      var data = response.data;

      if (data["isSuccess"] == true) {
        UserModel user = UserModel.fromJson(data["data"], fcmToken: fcmToken);
        box.write("token", data["data"]["access_token"]);
        box.write("refresh_token", data["data"]["refresh_token"]);
        box.write("user", data["data"]);
        box.write("role", user.roles.contains('distributor') ? "distributor" : "rep");

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

