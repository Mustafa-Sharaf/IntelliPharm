

import 'validation_strategy.dart';
//chain of responsibility
class ValidationContext {
  final List<ValidationStrategy> strategies;

  ValidationContext(this.strategies);

  String? validateAll() {
    for (final strategy in strategies) {
      final result = strategy.validate();
      if (result != null) return result;
    }
    return null;
  }
}
