import 'package:flutter/material.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../app_theme/theme_extension.dart';
import '../modules/MyDeliveries/MyDeliveries_Controller.dart';

class DeliveryCard extends StatelessWidget {
  final String orderId;
  final String clientName;
  final String address;
  final int itemsCount;
  final double price;
  final String estTime;
  final String assignedTime;
  final OrderPriority priority;
  final OrderStatus status;
  final bool isHospital;
  final VoidCallback onStartDelivery;

  const DeliveryCard({
    super.key,
    required this.orderId,
    required this.clientName,
    required this.address,
    required this.itemsCount,
    required this.price,
    required this.estTime,
    required this.assignedTime,
    required this.priority,
    required this.status,
    required this.isHospital,
    required this.onStartDelivery,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).extension<ThemeColors>()!;

    final priorityConfig = {
      OrderPriority.urgent: {
        'text': 'URGENT',
        'bg': const Color(0xffFDE8E8),
        'font': const Color(0xffE02424),
      },
      OrderPriority.normal: {
        'text': 'NORMAL',
        'bg': const Color(0xffE1EFFE),
        'font': const Color(0xff1E429F),
      },
      OrderPriority.low: {
        'text': 'LOW',
        'bg': const Color(0xffF3F4F6),
        'font': const Color(0xff4B5563),
      },
    }[priority]!;

    final statusConfig = {
      OrderStatus.pending: {
        'btnText': 'Start Delivery',
        'btnColor': AppColors.primaryColor,
        'enabled': true,
      },
      OrderStatus.inTransit: {
        'btnText': 'In Transit...',
        'btnColor': Colors.blue, //const Color(0xff2563EB)
        'enabled': false,
      },
      OrderStatus.delivered: {
        'btnText': 'Delivered Successfully',
        'btnColor': Colors.green, //const Color(0xff137333)
        'enabled': false,
      },
    }[status]!;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.01,
      ),
      padding: EdgeInsets.all(size.width * 0.045),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.textSecondary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW: ORDER ID & PRIORITY BADGE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "#$orderId",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: priorityConfig['bg'] as Color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  priorityConfig['text'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: priorityConfig['font'] as Color,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),

          /// INFO ROW: ICON + NAME & ADDRESS
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width * 0.11,
                height: size.width * 0.11,
                decoration: BoxDecoration(
                  color: colors.backgroundMain,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isHospital
                      ? Icons.local_hospital_rounded
                      : Icons.local_pharmacy_rounded,
                  color: colors.textPrimary,
                  size: size.width * 0.06,
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clientName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: size.height * 0.02),

          /// DOTTED DIVIDER
          Row(
            children: List.generate(
              30,
              (index) => Expanded(
                child: Container(
                  color: index % 2 == 0
                      ? Colors.transparent
                      : colors.textSecondary.withValues(alpha: 0.3),
                  height: 1.5,
                ),
              ),
            ),
          ),

          SizedBox(height: size.height * 0.02),

          /// METRICS ROW: INVENTORY & SCHEDULE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "INVENTORY",
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textDefault,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  SizedBox(height: size.height * 0.003),
                  Text(
                    "$itemsCount items · \$${price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SCHEDULE",
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textDefault,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  SizedBox(height: size.height * 0.003),
                  Text(
                    "EST: $estTime",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: size.height * 0.02),

          /// ASSIGNED TIME INDICATOR
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: colors.textSecondary),
              SizedBox(width: size.width * 0.015),
              Text(
                "Assigned: $assignedTime",
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textSecondary,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),

          SizedBox(height: size.height * 0.02),

          /// ACTION BUTTON DYNAMIC BASED ON STATUS
          SizedBox(
            width: double.infinity,
            height: size.height * 0.06,
            child: ElevatedButton(
              onPressed: (statusConfig['enabled'] as bool)
                  ? onStartDelivery
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: statusConfig['btnColor'] as Color,
                disabledBackgroundColor: (statusConfig['btnColor'] as Color)
                    .withValues(alpha: 0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                statusConfig['btnText'] as String,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
