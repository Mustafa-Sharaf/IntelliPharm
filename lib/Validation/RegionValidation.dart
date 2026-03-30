



import 'package:intellipharm/Validation/validation_strategy.dart';

import '../Widgets/RegionSelector/RegionSelector_Model.dart';

class RegionValidation implements ValidationStrategy {
  final RegionModel? region;

  RegionValidation(this.region);

  @override
  String? validate() {
    if (region == null) {
      return "Please select a region";
    }
    return null;
  }
}