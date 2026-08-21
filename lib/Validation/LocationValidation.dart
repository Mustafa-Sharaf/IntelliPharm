




import 'package:get/get.dart';
import 'package:intellipharm/Validation/validation_strategy.dart';

class LocationValidation implements ValidationStrategy {
  final double lat;
  final double lng;

  LocationValidation(this.lat, this.lng);

  @override
  String? validate() {
    if (lat == 0 || lng == 0) {
      return "Please select location".tr;
    }
    return null;
  }
}