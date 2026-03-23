import 'validation_strategy.dart';

class EmptyFieldsValidation implements ValidationStrategy {
  final List<String> fields;

  EmptyFieldsValidation(this.fields);

  @override
  String? validate() {
    if (fields.any((f) => f.trim().isEmpty)) {
      return "Please fill in all fields";
    }
    return null;
  }
}
