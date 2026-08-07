import 'package:flutter/material.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../app_theme/theme_extension.dart';
import '../modules/PharmacyDebts/PharmacyDebt_Model.dart';

class BuildPharmacyCardDebts extends StatelessWidget {
  final PharmacyDebtModel item;

  const BuildPharmacyCardDebts({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final Color accentColor;
    final String statusText;

    switch (item.status) {
      case PaymentStatus.overdue:
        accentColor = const Color(0xFFD32F2F);
        statusText = 'OVERDUE';
        break;
      case PaymentStatus.partial:
        accentColor = const Color(0xFFE65100);
        statusText = 'PARTIAL';
        break;
      case PaymentStatus.paid:
        accentColor = const Color(0xFF2E7D32);
        statusText = 'PAID';
        break;
    }

    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.02),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: size.height * 0.01,
            bottom: size.height * 0.01,
            child: Container(
              width: size.width * 0.01,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size.height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: colors.textSecondary,
                            ),
                            SizedBox(width: size.width * 0.01),
                            Text(
                              item.location,
                              style: TextStyle(
                                color: colors.textSecondary,
                                fontSize: 12,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.02,
                        vertical: size.height * 0.005,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.01,
                    horizontal: size.width * 0.02,
                  ),
                  decoration: BoxDecoration(
                    color: colors.backgroundMain,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAmountColumn(
                        'Total',
                        '${item.totalAmount} S.p',
                        colors.textDefault,
                        context,
                      ),
                      Container(
                        height: size.height * 0.035,
                        width: size.width * 0.002,
                        color: colors.textSecondary,
                      ),
                      _buildAmountColumn(
                        'Paid',
                        '${item.paidAmount} S.p',
                        AppColors.primaryColor,
                        context,
                      ),
                      Container(
                        height: size.height * 0.035,
                        width: size.width * 0.002,
                        color: colors.textSecondary,
                      ),
                      _buildAmountColumn(
                        'Remaining',
                        '${item.remainingAmount} S.p',
                        item.remainingAmount > 0
                            ? accentColor
                            : AppColors.primaryColor,
                        context,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: item.paidPercentage,
                          minHeight: 6,
                          backgroundColor: colors.backgroundMain,
                          color: item.status == PaymentStatus.paid
                              ? const Color(0xFF2E7D32)
                              : AppColors.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.01),
                    Text(
                      '${(item.paidPercentage * 100).toInt()}% paid',
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 11,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                Divider(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Last payment: ${item.lastPaymentDate}',
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 11,
                        fontFamily: 'Cairo',
                      ),
                    ),
                     Icon(
                      Icons.chevron_right,
                       color: colors.textSecondary,
                      size: size.height * 0.03,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountColumn(
    String label,
    String value,
    Color valueColor,
    BuildContext context,
  ) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 11,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}
