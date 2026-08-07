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
  final String status; // 🔹 القيمة الخام القادمة من الـ API (مثل "PENDING" أو "ON_THE_WAY")
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

    // 🔹 تحويل الحالة الخام إلى حروف صغيرة واستبدال المسافات والشرطات السفلية
    final rawStatus = status.toLowerCase().replaceAll("_", " ").trim();

    // 🔹 المقارنة تتم الآن على الحالة الإنجليزية الأصلية بغض النظر عن لغة التطبيق
    final canCancel = rawStatus == 'pending' ||
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
            height: size.height * 0.14,
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
                        "ORDER_ID".trParams({
                          'id': orderId.toString(),
                        }),
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
                          status.tr, // 👈 نقوم بالترجمة هنا فقط للشاشات والواجهة!
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

                      if (canCancel)
                        IconButton(
                          onPressed: onCancel,
                          icon: const Icon(
                            Icons.block,
                            color: Colors.red,
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
                      GestureDetector(
                        onTap: () {
                          final id = int.parse(orderId);
                          Get.to(
                                () => ShowOrderScreen(orderId: id),
                            binding: ShowOrderBinding(id),
                          );
                        },
                        child: Icon(
                          Icons.chevron_right,
                          color: colors.textSecondary,
                        ),
                      )
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