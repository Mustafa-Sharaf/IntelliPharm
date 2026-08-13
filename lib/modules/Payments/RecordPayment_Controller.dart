import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      Get.snackbar(
        'Error'.tr,
        'invalid_amount_err'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    // إرسال pharmacyId الصحيح (مثلاً 400)
    final request = RecordPaymentModel(
      pharmacyId: pharmacy.pharmacyId,
      amount: enteredAmount.value,
      paymentDate: DateFormat('yyyy-MM-dd').format(selectedDate.value),
    );

    // طباعة الـ payload الحقيقي للتأكد
    print("Sending Payment Payload: ${request.toJson()}");

    try {
      final responseData = await RecordPaymentService.createPayment(request);

      if (responseData != null && responseData['isSuccess'] == true) {
        Get.back(result: true);
        Get.snackbar(
          'Success'.tr,
          'payment_success_msg'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        String msg = responseData?['message'] ?? 'Failed to process payment';
        Get.snackbar(
          'Error'.tr,
          msg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
/*  Future<void> submitPayment() async {
    if (enteredAmount.value <= 0) {
      Get.snackbar(
        'Error'.tr,
        'invalid_amount_err'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    final request = RecordPaymentModel(
      pharmacyId: int.tryParse(pharmacy.pharmacyId.toString()) ?? 0,
      amount: enteredAmount.value,
      paymentDate: DateFormat('yyyy-MM-dd').format(selectedDate.value),
    );
    print("pharmacyId= ${int.tryParse(pharmacy.pharmacyId.toString())}");

    try {
      final responseData = await RecordPaymentService.createPayment(request);

      // الفحص بناءً على رد الـ API الخاص بك
      if (responseData != null && responseData['isSuccess'] == true) {
        Get.back(result: true); // العودة للشاشة السابقة وإعلامها بنجاح العملية
        Get.snackbar(
          'Success'.tr,
          'payment_success_msg'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        String msg = responseData?['message'] ?? 'Failed to process payment';
        Get.snackbar(
          'Error'.tr,
          msg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }*/
}