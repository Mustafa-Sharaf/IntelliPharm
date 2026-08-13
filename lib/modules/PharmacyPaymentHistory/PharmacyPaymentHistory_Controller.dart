import 'package:get/get.dart';
import '../../services/ServiceApi/PharmacyPaymentHistoryService.dart';
import 'PharmacyPaymentHistory_Model.dart';


class PharmacyPaymentHistoryController extends GetxController {
  final selectedTabIndex = 0.obs;

  final RxList<PaymentItemModel> paymentsList = <PaymentItemModel>[].obs;
  final RxList<InvoiceItemModel> invoicesList = <InvoiceItemModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  Future<void> loadPharmacyHistory(String debtId) async {
    try {
      isLoading.value = true;
      isError.value = false;

      final result = await PharmacyPaymentHistoryService.getDebtDetails(debtId);

      paymentsList.assignAll(result.payments);
      invoicesList.assignAll(result.invoices);
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString().replaceAll("Exception:", "");
    } finally {
      isLoading.value = false;
    }
  }
}