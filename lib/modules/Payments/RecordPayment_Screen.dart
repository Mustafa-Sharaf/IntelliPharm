import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../PharmacyDebts/PharmacyDebt_Model.dart';
import 'HeaderPaymentScreen.dart';
import 'PaymentsDateCart.dart';
import 'RecordPayment_Controller.dart';

class RecordPaymentScreen extends StatelessWidget {
  final PharmacyDebtModel pharmacy;

  const RecordPaymentScreen({super.key, required this.pharmacy});

  String _formatAmount(double amount) {
    return NumberFormat('#,##0.##', 'en_US').format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecordPaymentController>();
    controller.initData(pharmacy);
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        backgroundColor: colors.backgroundMain,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'record_payment_title'.tr,
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.01,
        ),
        child: Column(
          children: [
            HeaderPaymentScreen(pharmacy: pharmacy),
            SizedBox(height: size.height * 0.025),
            Text(
              'payment_amount_label'.tr,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colors.component,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: controller.amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.center,
                onChanged: controller.onAmountChanged,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                  fontFamily: 'Cairo',
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '0.00',
                  hintStyle: TextStyle(
                    color: colors.textSecondary.withValues(alpha: 0.4),
                    fontFamily: 'Cairo'
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'S.p',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colors.textSecondary,
                          fontFamily: 'Cairo'
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.005),
            Text(
              'type_to_edit_hint'.tr,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 11,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: size.height * 0.025),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.component.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Obx(
                () => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'current_balance_label'.tr,
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 13,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        Text(
                          'amount_sp'.trParams({
                            'amount': _formatAmount(pharmacy.remainingAmount),
                          }),
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                     SizedBox(height: size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'payment_label'.tr,
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 13,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        Text(
                          '-${'amount_sp'.trParams({'amount': _formatAmount(controller.enteredAmount.value)})}',
                          style:  TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                     Divider(height: size.height*0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'new_balance_label'.tr,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        Text(
                          'amount_sp'.trParams({
                            'amount': _formatAmount(controller.newBalance),
                          }),
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * 0.025),
            PaymentsDateCart(),
            SizedBox(height: size.height * 0.02),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: 10,
          ),
          child: Obx(
            () => SizedBox(
              height: size.height * 0.06,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: controller.isLoading.value
                    ? null
                    : controller.submitPayment,
                icon: controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                      ),
                label: Text(
                  'confirm_payment_btn'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
