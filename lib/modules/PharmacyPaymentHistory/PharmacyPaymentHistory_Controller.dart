/*
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
}*/
import 'package:get/get.dart';
import '../../services/ServiceApi/PharmacyPaymentHistoryService.dart';
import '../PharmacyDebts/PharmacyDebt_Model.dart';
import 'PharmacyPaymentHistory_Model.dart';

class PharmacyPaymentHistoryController extends GetxController {
  final selectedTabIndex = 0.obs;

  final RxList<PaymentItemModel> paymentsList = <PaymentItemModel>[].obs;
  final RxList<InvoiceItemModel> invoicesList = <InvoiceItemModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;

  // متغير تفاعلي لتحديث واجهة الهيدر دون الحاجة لتعديل response model
  final Rxn<PharmacyDebtModel> pharmacyData = Rxn<PharmacyDebtModel>();

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

      // حساب الإجماليات ديناميكياً من الفواتير المرجعة
      if (invoicesList.isNotEmpty) {
        final totalBilled = invoicesList.fold(0.0, (sum, item) => sum + item.totalAmount);
        final totalPaid = invoicesList.fold(0.0, (sum, item) => sum + item.paidAmount);
        final totalRemaining = invoicesList.fold(0.0, (sum, item) => sum + item.remainingAmount);

        // آخر تاريخ دفعة
        final lastDate = paymentsList.isNotEmpty ? paymentsList.first.date : 'N/A';

        // تحديد الحالة
        PaymentStatus currentStatus = PaymentStatus.overdue;
        if (totalRemaining == 0) {
          currentStatus = PaymentStatus.paid;
        } else if (totalPaid > 0) {
          currentStatus = PaymentStatus.partial;
        }

        pharmacyData.value = PharmacyDebtModel(
          id: debtId,
          pharmacyId: result.debtId,
          name: '',
          location: '',
          totalAmount: totalBilled,
          paidAmount: totalPaid,
          remainingAmount: totalRemaining,
          lastPaymentDate: lastDate,
          status: currentStatus,
        );
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString().replaceAll("Exception:", "");
    } finally {
      isLoading.value = false;
    }
  }
}