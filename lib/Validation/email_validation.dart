import 'validation_strategy.dart';

class EmailValidation implements ValidationStrategy {
  final String email;

  EmailValidation(this.email);

  @override
  String? validate() {
    if (!email.contains('@') || !email.contains('.')) {
      return "Please enter a valid email address";
    }
    return null;
  }
}
