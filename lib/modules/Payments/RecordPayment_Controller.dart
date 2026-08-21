import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/widgets/AppSnackBar.dart';
import 'package:intl/intl.dart';
import '../../services/ServiceApi/RecordPaymentService.dart';
import '../PharmacyDebts/PharmacyDebt_Model.dart';
import 'RecordPayment_Model.dart';

class RecordPaymentController extends GetxController {
  late PharmacyDebtModel pharmacy;

  final amountController = TextEditingController();
  final notesController = TextEditingController();

  var selectedDate = DateTime.now().obs;
  var isLoading = false.obs;
  var enteredAmount = 0.0.obs;

  void initData(PharmacyDebtModel pharmacyData) {
    pharmacy = pharmacyData;
  }

  @override
  void onClose() {
    amountController.dispose();
    notesController.dispose();
    super.onClose();
  }

  void onAmountChanged(String val) {
    final parsed = double.tryParse(val) ?? 0.0;
    enteredAmount.value = parsed;
  }

  double get newBalance {
    final res = pharmacy.remainingAmount - enteredAmount.value;
    return res < 0 ? 0.0 : res;
  }

  void pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }
  Future<void> submitPayment() async {
    if (enteredAmount.value <= 0) {
      AppSnackBar.error('invalid_amount_err'.tr,);

      return;
    }

    isLoading.value = true;

    final request = RecordPaymentModel(
      pharmacyId: pharmacy.pharmacyId,
      amount: enteredAmount.value,
      paymentDate: DateFormat('yyyy-MM-dd').format(selectedDate.value),
      note: notesController.text,
    );

    print("Sending Payment Payload: ${request.toJson()}");

    try {
      final responseData = await RecordPaymentService.createPayment(request);

      if (responseData != null && responseData['isSuccess'] == true) {
        Get.back(result: true);
        AppSnackBar.success('payment_success_msg'.tr,);
      } else {
        String msg = responseData?['message'] ?? '';
        AppSnackBar.error('Failed to process payment'.tr,);
      }
    } catch (e) {
      print(e.toString(),);

    } finally {
      isLoading.value = false;
    }
  }

}