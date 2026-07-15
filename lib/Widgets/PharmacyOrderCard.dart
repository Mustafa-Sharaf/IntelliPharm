import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_theme/theme_extension.dart';

enum OrderPriority { urgent, normal, low }
enum OrderStatus { pending, inTransit, delivered }


extension OrderPriorityExtension on OrderPriority {
  String get text {
    switch (this) {
      case OrderPriority.urgent:
        return 'URGENT'.tr;
      case OrderPriority.normal:
        return 'NORMAL'.tr;
      case OrderPriority.low:
        return 'LOW'.tr;
    }
  }

  Color get bgColor {
    switch (this) {
      case OrderPriority.urgent:
        return const Color(0xffFDE8E8);
      case OrderPriority.normal:
        return const Color(0xffE1EFFE);
      case OrderPriority.low:
        return const Color(0xffF3F4F6);
    }
  }

  Color get fontColor {
    switch (this) {
      case OrderPriority.urgent:
        return const Color(0xffE02424);
      case OrderPriority.normal:
        return const Color(0xff1E429F);
      case OrderPriority.low:
        return const Color(0xff4B5563);
    }
  }
}

extension OrderStatusExtension on OrderStatus {
  String get text {
    switch (this) {
      case OrderStatus.pending:
        return 'PENDING'.tr;
      case OrderStatus.inTransit:
        return 'IN_TRANSIT'.tr;
      case OrderStatus.delivered:
        return 'DELIVERED'.tr;
    }
  }

  Color get bgColor {
    switch (this) {
      case OrderStatus.pending:
        return const Color(0xffFEF6EE);
      case OrderStatus.inTransit:
        return const Color(0xffEBF5FF);
      case OrderStatus.delivered:
        return const Color(0xffE6F4EA);
    }
  }

  Color get fontColor {
    switch (this) {
      case OrderStatus.pending:
        return const Color(0xffD97706);
      case OrderStatus.inTransit:
        return const Color(0xff2563EB);
      case OrderStatus.delivered:
        return const Color(0xff137333);
    }
  }
}

class PharmacyOrderCard extends StatelessWidget {
  final String orderNumber;
  final String pharmacyName;
  final int itemsCount;
  final OrderPriority priority;
  final OrderStatus status;
  final VoidCallback? onTap;

  const PharmacyOrderCard({
    super.key,
    required this.orderNumber,
    required this.pharmacyName,
    required this.itemsCount,
    required this.priority,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: size.width * 0.012,
      ),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.045),
          child: Row(
            children: [
              /// MAIN CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ORDER NUMBER + PRIORITY BADGE
                    Row(
                      children: [
                        Text(
                          // "Order #$orderNumber"
                          "ORDER_NUMBER".trParams({
                            'number': orderNumber.toString(),
                          }),
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.textSecondary.withValues(alpha: 0.8),
                            fontFamily: 'Cairo',
                          ),
                        ),
                        SizedBox(width: size.width * 0.025),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.03,
                            vertical: size.width * 0.006,
                          ),
                          decoration: BoxDecoration(
                            color: priority.bgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            priority.text,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: priority.fontColor,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.008),

                    /// PHARMACY NAME
                    Text(
                      pharmacyName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(height: size.height * 0.008),

                    /// ITEMS + STATUS BADGE WITH DOT
                    Row(
                      children: [
                        Text(
                          // "$itemsCount items"
                          "ITEMS_COUNT".trParams({
                            'count': itemsCount.toString(),
                          }),
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.textSecondary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        SizedBox(width: size.width * 0.04),

                        /// STATUS WITH DOT
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.03,
                            vertical: size.width * 0.008,
                          ),
                          decoration: BoxDecoration(
                            color: status.bgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: status.fontColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: size.width * 0.015),
                              Text(
                                status.text,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: status.fontColor,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// RIGHT CHEVRON ARROW
              Icon(
                Icons.chevron_right_rounded,
                color: const Color(0xffC6D2E1),
                size: size.width * 0.065,
              ),
            ],
          ),
        ),
      ),
    );
  }
}