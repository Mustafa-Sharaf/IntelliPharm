/*
import 'package:get/get.dart';
import '../PharmacyDebts/PharmacyDebt_Model.dart';


class PaymentItemModel {
  final String id;
  final double amount;
  final String date;
  final String paymentMethod;
  final String ref;
  final String collectedBy;
  final double balanceAfter;

  PaymentItemModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.paymentMethod,
    required this.ref,
    required this.collectedBy,
    required this.balanceAfter,
  });
}

class InvoiceItemModel {
  final String id;
  final String orderCode;
  final double totalAmount;
  final double paidAmount;
  final PaymentStatus status;

  double get remainingAmount => totalAmount - paidAmount;

  InvoiceItemModel({
    required this.id,
    required this.orderCode,
    required this.totalAmount,
    required this.paidAmount,
    required this.status,
  });
}

class PharmacyPaymentHistoryController extends GetxController {
  // حالة التاب المختار (0: Payments, 1: Invoices)
  final selectedTabIndex = 0.obs;

  // القوائم
  final RxList<PaymentItemModel> paymentsList = <PaymentItemModel>[].obs;
  final RxList<InvoiceItemModel> invoicesList = <InvoiceItemModel>[].obs;
  final RxBool isLoading = true.obs;

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  // جلب سجل الدفعات والفواتير بناءً على ID الصيدلية
  Future<void> loadPharmacyHistory(String pharmacyId) async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300)); // محاكاة الـ API

    paymentsList.assignAll([
      PaymentItemModel(
        id: 'p1',
        amount: 500,
        date: 'Apr 3, 2026 • 2:35 PM',
        paymentMethod: 'BANK TRANSFER',
        ref: 'PAY-1042',
        collectedBy: 'Ahmad',
        balanceAfter: 1700,
      ),
      PaymentItemModel(
        id: 'p2',
        amount: 800,
        date: 'Mar 15, 2026 • 10:15 AM',
        paymentMethod: 'CASH',
        ref: 'PAY-0988',
        collectedBy: 'Ahmad',
        balanceAfter: 2200,
      ),
      PaymentItemModel(
        id: 'p3',
        amount: 800,
        date: 'Mar 17, 2026 • 11:15 AM',
        paymentMethod: 'CASH',
        ref: 'PAY-0988',
        collectedBy: 'Ahmad',
        balanceAfter: 2400,
      ),
    ]);

    invoicesList.assignAll([
      InvoiceItemModel(
        id: 'inv1',
        orderCode: 'ORD-5542',
        totalAmount: 1500,
        paidAmount: 1500,
        status: PaymentStatus.paid,
      ),
      InvoiceItemModel(
        id: 'inv2',
        orderCode: 'ORD-5610',
        totalAmount: 1000,
        paidAmount: 500,
        status: PaymentStatus.partial,
      ),
      InvoiceItemModel(
        id: 'inv3',
        orderCode: 'ORD-5688',
        totalAmount: 700,
        paidAmount: 0,
        status: PaymentStatus.overdue,
      ),
    ]);

    isLoading.value = false;
  }
}*/
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