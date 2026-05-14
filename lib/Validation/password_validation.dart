import 'package:get/get.dart';
import 'validation_strategy.dart';

class PasswordValidation implements ValidationStrategy {
  final String password;

  PasswordValidation(this.password);

  final RegExp regex =
  RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&]).{6,}$');

  @override
  String? validate() {
    if (password.length < 6) {
      return "Password_must_beat_least_8_characters".tr;
    }
    /*if (!regex.hasMatch(password)) {
      return "Password_must_contain_letters_numbers_and_special_characters".tr;
    }*/

    return null;
  }
}
