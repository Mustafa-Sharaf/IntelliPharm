import 'package:get/get.dart';

import 'RecordPayment_Controller.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecordPaymentController>(
      () => RecordPaymentController(),
      fenix: true,
    );
  }
}
