
import 'package:get/get.dart';
import 'SignIn_Controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(
          () => SignInController(),
    );
  }
}