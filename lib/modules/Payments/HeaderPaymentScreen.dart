
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import 'package:get/get.dart';

import '../PharmacyDebts/PharmacyDebt_Model.dart';


class HeaderPaymentScreen extends StatelessWidget {
   const HeaderPaymentScreen({super.key, required this.pharmacy});
  final PharmacyDebtModel pharmacy;

  String _formatAmount(double amount) {
    return NumberFormat('#,##0.##', 'en_US').format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    return  Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.textSecondary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.storefront_outlined,
                  color: AppColors.primaryColor,
                  size: 26,
                ),
              ),
              SizedBox(width: size.width * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pharmacy.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: colors.textPrimary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      pharmacy.location,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(height: size.height * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'outstanding_balance_label'.tr,
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
              Text(
                'amount_sp'.trParams({
                  'amount': _formatAmount(pharmacy.remainingAmount),
                }),
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
