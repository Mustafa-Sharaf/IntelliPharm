import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../modules/PharmacyDebts/PharmacyDebt_Model.dart';

class PharmacySummaryHeaderCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double remainingAmount;
  final double totalBilled;
  final double totalPaid;
  final PaymentStatus? status;

  const PharmacySummaryHeaderCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.remainingAmount,
    required this.totalBilled,
    required this.totalPaid,
    this.status,
  });

  String _formatAmount(double amount) {
    final formatter = NumberFormat('#,##0.##', 'en_US');
    return

    'amount_sp'.trParams({'amount': formatter.format(amount)});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double paidPercentage = totalBilled == 0
        ? 0
        : (totalPaid / totalBilled);
    final int collectedPercentInt = (paidPercentage * 100).toInt();
    final int remainingPercentInt = 100 - collectedPercentInt;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF023E68), Color(0xFF005B60)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(height: size.height * 0.005),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _formatAmount(remainingAmount),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.032,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: size.height * 0.003),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (status != null) _buildStatusBadge(status!),
            ],
          ),
          SizedBox(height: size.height * 0.015),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total_Paid'.tr,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(height: size.height * 0.003),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        _formatAmount(totalPaid),
                        style: const TextStyle(
                          color: Color(0xFF4EE1C2),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total_Billed'.tr,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(height: size.height * 0.003),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _formatAmount(totalBilled),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.012),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: paidPercentage.clamp(0.0, 1.0),
              minHeight: size.height * 0.008,
              backgroundColor: Colors.white24,
              color: const Color(0xFF4EE1C2),
            ),
          ),
          SizedBox(height: size.height * 0.008),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                //'$collectedPercentInt% Collected',
                'percent_collected'.trParams({
                  'percent': collectedPercentInt.toString(),
                }),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontFamily: 'Cairo',
                ),
              ),
              Text(
                'percent_remaining'.trParams({
                  'percent': remainingPercentInt.toString(),
                }),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(PaymentStatus status) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case PaymentStatus.paid:
        bg = const Color(0xFFD1FAE5);
        text = const Color(0xFF065F46);
        label = 'PAID';
        break;
      case PaymentStatus.partial:
        bg = const Color(0xFFFFEDD5);
        text = const Color(0xFF9A3412);
        label = 'PARTIAL';
        break;
      case PaymentStatus.pending:
        bg = const Color(0xFFFEF3C7);
        text = const Color(0xFF92400E);
        label = 'PENDING';
        break;
      case PaymentStatus.overdue:
        bg = const Color(0xFFFEE2E2);
        text = const Color(0xFF991B1B);
        label = 'OVERDUE';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label.tr,
        style: TextStyle(
          color: text,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }
}
