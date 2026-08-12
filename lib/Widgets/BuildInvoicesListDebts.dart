import 'package:flutter/material.dart';
import '../../app_theme/theme_extension.dart';
import '../modules/PharmacyDebts/PharmacyDebt_Model.dart';
import '../modules/PharmacyPaymentHistory/PharmacyPaymentHistory_Controller.dart';

class BuildInvoicesListDebts extends StatelessWidget {
  final PharmacyPaymentHistoryController controller;

  const BuildInvoicesListDebts({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.invoicesList.length,
      itemBuilder: (context, index) {
        final item = controller.invoicesList[index];

        final statusConfig = _getStatusConfig(item.status);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: colors.component,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Positioned(
                top: size.height * 0.01,
                bottom: size.height * 0.01,
                child: Container(
                  width: size.width * 0.01,
                  decoration: BoxDecoration(
                    color: statusConfig.color,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(size.width * 0.04),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              item.orderCode,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                                fontSize: 15,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            SizedBox(width: size.width * 0.01),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.01,
                                vertical: size.height * 0.003,
                              ),
                              decoration: BoxDecoration(
                                color: statusConfig.color.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                statusConfig.label,
                                style: TextStyle(
                                  color: statusConfig.color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${item.totalAmount.toStringAsFixed(0)} S.p',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                            fontSize: 15,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Mar 15, 2026',
                          style: TextStyle(
                            fontSize: 10,
                            color: colors.textSecondary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                    Divider(height: size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PAID',
                              style: TextStyle(
                                fontSize: 10,
                                color: colors.textSecondary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            Text(
                              '${item.paidAmount.toStringAsFixed(0)} S.p',
                              style: TextStyle(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'REMAINING',
                              style: TextStyle(
                                fontSize: 10,
                                color: colors.textSecondary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            Text(
                              '${item.remainingAmount.toStringAsFixed(0)} S.p',
                              style: TextStyle(
                                color: item.remainingAmount > 0
                                    ? Colors.red.shade400
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  ({Color color, String label}) _getStatusConfig(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return (color: Colors.teal, label: 'PAID');
      case PaymentStatus.partial:
        return (color: Colors.orange, label: 'PARTIAL');
      case PaymentStatus.pending:
        return (color: Colors.amber, label: 'PENDING');
      case PaymentStatus.overdue:
        return (color: Colors.red, label: 'UNPAID');
    }
  }
}
