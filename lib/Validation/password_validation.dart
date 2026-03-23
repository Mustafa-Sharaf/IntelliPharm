import 'validation_strategy.dart';

class PasswordValidation implements ValidationStrategy {
  final String password;

  PasswordValidation(this.password);

  final RegExp regex =
  RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&]).{6,}$');

  @override
  String? validate() {
    if (!regex.hasMatch(password)) {
      return "Password must contain letters, numbers, and special characters";
    }
    return null;
  }
}
