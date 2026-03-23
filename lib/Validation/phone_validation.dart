import 'validation_strategy.dart';

class PhoneValidation implements ValidationStrategy {
  final String phone;

  PhoneValidation(this.phone);

  @override
  String? validate() {
    if (phone.length != 10 || !phone.startsWith("09")) {
      return "Phone number must start with 09 and be exactly 10 digits";
    }
    return null;
  }
}
