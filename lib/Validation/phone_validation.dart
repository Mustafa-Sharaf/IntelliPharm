import 'package:get/get.dart';
import 'validation_strategy.dart';

class PhoneValidation implements ValidationStrategy {
  final String phone;

  PhoneValidation(this.phone);

  @override
  String? validate() {
    if (phone.length != 10 || !phone.startsWith("09")) {
      return "Phone_number_must_start_with_09_and_be_exactly_10_digits".tr;
    }
    return null;
  }
}
