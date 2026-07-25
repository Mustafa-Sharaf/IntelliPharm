import 'package:get/get.dart';
import '../AddNotes/AddNotes_Controller.dart';
import '../PharmacyDetails/PharmacyDetails_Controller.dart';
import 'VisitDetails_Controller.dart';

class VisitDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final Map<String, dynamic> args = Get.arguments;
    final int pharmacyId = args["pharmacyId"];

    // 1. حقن PharmacyDetailsController باستخدام tag الصيدلية
    Get.lazyPut<PharmacyDetailsController>(
          () => PharmacyDetailsController(),
      tag: pharmacyId.toString(),
    );

    // 2. حقن VisitDetailsController الخاص بتبويبات وتفاصيل الزيارة
    Get.lazyPut<VisitDetailsController>(
          () => VisitDetailsController(),
    );
    Get.lazyPut<AddNotesController>(() => AddNotesController(), fenix: true);
  }
}