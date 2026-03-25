import 'package:get/get.dart';

import 'validation_strategy.dart';

class EmailValidation implements ValidationStrategy {
  final String email;

  EmailValidation(this.email);

  @override
  String? validate() {
    if (!email.contains('@') || !email.contains('.')) {
      return "Please_enter_a_valid_email_address".tr;
    }
    return null;
  }
}
