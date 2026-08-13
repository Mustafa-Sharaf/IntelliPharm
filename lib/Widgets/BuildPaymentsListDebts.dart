/*
import 'package:flutter/material.dart';
import '../../app_theme/theme_extension.dart';
import '../modules/PharmacyPaymentHistory/PharmacyPaymentHistory_Controller.dart';

class BuildPaymentsListDebts extends StatelessWidget {
  final PharmacyPaymentHistoryController controller;
  const BuildPaymentsListDebts({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.paymentsList.length,
      itemBuilder: (context, index) {
        final item = controller.paymentsList[index];
        final isLast = index == controller.paymentsList.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.001),
                    padding: EdgeInsets.all(size.height * 0.002),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4EE1C2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                  if (isLast)
                    Container(
                      width: size.width * 0.004,
                      height: size.height * 0.14,
                      color: Colors.grey,
                    )
                  else
                    Expanded(
                      child: Container(
                        width: size.width * 0.004,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.component,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '+${item.amount} S.p',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colors.textSecondary.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.paymentMethod,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: colors.textSecondary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.005),
                      Text(
                        item.date,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 11,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      Divider(height: size.height * 0.01),
                      _buildRowDetail('Ref:', item.ref, colors),
                      _buildRowDetail(
                        'Collected by:',
                        item.collectedBy,
                        colors,
                      ),
                      _buildRowDetail(
                        'Balance after:',
                        '${item.balanceAfter} S.p',
                        colors,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRowDetail(
    String label,
    String value,
    ThemeColors colors, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 12,
              fontFamily: 'Cairo',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app_theme/theme_extension.dart';
import '../modules/PharmacyPaymentHistory/PharmacyPaymentHistory_Controller.dart';

class BuildPaymentsListDebts extends StatelessWidget {
  final PharmacyPaymentHistoryController controller;
  const BuildPaymentsListDebts({super.key, required this.controller});

  String _formatAmount(double amount) {
    return NumberFormat('#,##0.##', 'en_US').format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    if (controller.paymentsList.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
        child: Center(
          child: Text(
            'no_payments_found'.tr,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 14,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.paymentsList.length,
      itemBuilder: (context, index) {
        final item = controller.paymentsList[index];
        final isLast = index == controller.paymentsList.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.005),
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4EE1C2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: colors.textSecondary.withValues(alpha: 0.3),
                      ),
                    ),
                ],
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.component,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'payment_amount'.trParams({
                                'amount': _formatAmount(item.amount),
                              }),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colors.textSecondary.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.paymentMethod,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: colors.textSecondary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.005),
                      Text(
                        item.date,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 11,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      Divider(height: size.height * 0.015),
                      _buildRowDetail('ref_label'.tr, item.ref, colors),
                      _buildRowDetail(
                        'collected_by_label'.tr,
                        item.collectedBy,
                        colors,
                      ),
                      _buildRowDetail(
                        'balance_after_label'.tr,
                        'balance_amount_sp'.trParams({
                          'amount': _formatAmount(item.balanceAfter),
                        }),
                        colors,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRowDetail(
      String label,
      String value,
      ThemeColors colors, {
        bool isBold = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 12,
              fontFamily: 'Cairo',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}