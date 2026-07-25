import 'package:get/get.dart';
import '../AddNotes/AddNotes_Controller.dart';
import 'PharmacyDetails_Controller.dart';

class PharmacyDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final int pharmacyId = Get.arguments;
    Get.lazyPut<PharmacyDetailsController>(
          () => PharmacyDetailsController(),
      tag: pharmacyId.toString(),
    );
    Get.lazyPut<AddNotesController>(() => AddNotesController(), fenix: true);
  }
}