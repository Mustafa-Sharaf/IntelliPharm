
import '../../Validation/email_validation.dart';
import '../../Validation/empty_fields_validation.dart';
import '../../Validation/password_validation.dart';
import '../../Validation/validation_context.dart';

class LoginValidator {
  ///Strategy + Chain of Responsibility
  static String? validate(String email, String password) {
    final validator = ValidationContext([
      EmptyFieldsValidation([email, password]),
      EmailValidation(email),
      PasswordValidation(password),
    ]);

    return validator.validateAll();
  }
}