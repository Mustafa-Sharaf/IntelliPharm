import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_theme/theme_extension.dart';
import '../modules/ShowOrder/ShowOrderBinding.dart';
import '../modules/ShowOrder/ShowOrder_Screen.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final String pharmacyName;
  final String date;
  final String itemsCount;
  final String price;
  final String status;
  final Color statusColor;
  final VoidCallback? onCancel;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.pharmacyName,
    required this.date,
    required this.itemsCount,
    required this.price,
    required this.status,
    required this.statusColor,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    final rawStatus = status.toLowerCase().replaceAll("_", " ").trim();

    final canCancel =
        rawStatus == 'pending' ||
        rawStatus == 'processing' ||
        rawStatus == 'on the way';

    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: size.width * 0.008,
            height: size.height * 0.2,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 Order ID + Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ORDER_ID".trParams({'id': orderId.toString()}),
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 12,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.02,
                          vertical: size.width * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status.tr,
                          style: TextStyle(
                            color: statusColor,
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.004),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          pharmacyName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.004),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: colors.textSecondary,
                      ),
                      SizedBox(width: size.height * 0.004),
                      Text(
                        date,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontFamily: 'Cairo',
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.01,
                          vertical: size.width * 0.005,
                        ),
                        decoration: BoxDecoration(
                          color: colors.backgroundMain,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          itemsCount,
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontFamily: 'Cairo',
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.008),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 18,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.width * 0.02),
                  Divider(color: Colors.grey.shade200, height: 1),
                  SizedBox(height: size.width * 0.02),
                  Row(
                    children: [
                      if (canCancel)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: onCancel,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.red,
                                width: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: Text(
                              'Cancel Order'.tr,
                              style: TextStyle(
                                color: Colors.red,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(width: size.width * 0.02),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            final id = int.parse(orderId);
                            Get.to(
                              () => ShowOrderScreen(orderId: id),
                              binding: ShowOrderBinding(id),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: colors
                                  .textPrimary, //AppColors.textLightPrimary
                              width: 1.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: Text(
                            'Order details'.tr,
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
