import 'package:get/get.dart';

import 'validation_strategy.dart';

class EmptyFieldsValidation implements ValidationStrategy {
  final List<String> fields;

  EmptyFieldsValidation(this.fields);

  @override
  String? validate() {
    if (fields.any((f) => f.trim().isEmpty)) {
      return "Please_fill_in_all_fields".tr;
    }
    return null;
  }
}
