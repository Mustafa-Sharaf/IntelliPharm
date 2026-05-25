import 'package:get/get.dart';

class RePlanRouteController extends GetxController {
  String selectedReason = "Accident Ahead";

  List<int> selectedStops = [1];

  void selectReason(String reason) {
    selectedReason = reason;
    update();
  }

  void toggleStop(int index) {
    if (selectedStops.contains(index)) {
      selectedStops.remove(index);
    } else {
      selectedStops.add(index);
    }

    update();
  }
}