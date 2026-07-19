import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../modules/ActiveDeliveryRoute/ActiveDeliveryRoute_Controller.dart';
import '../modules/ActiveDeliveryRoute/ActiveDeliveryRoute_Model.dart';
import '../modules/ConfirmDelivery/ConfirmDelivery_Screen.dart';


class DeliveryTimelineItem extends StatelessWidget {
  final DeliveryVisit visit;
  final bool isCompleted;
  final bool isActive;
  final bool isLast;
  final String subtitleText;
  final VoidCallback onMarkDelivered;

  const DeliveryTimelineItem({
    super.key,
    required this.visit,
    required this.isCompleted,
    required this.isActive,
    required this.isLast,
    required this.subtitleText,
    required this.onMarkDelivered,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عمود مؤشر الخط الزمني (الدوائر والخطوط الواصلة)
        Column(
          children: [
            if (isCompleted)
              const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF76F2D6),
                child: Icon(Icons.check, color: Colors.white, size: 16),
              )
            else if (isActive)
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primaryColor, // استخدام اللون الأساسي للتطبيق للزيارة النشطة
                child: Text(
                  visit.visitOrder.toString(), // تم الإصلاح هنا ليعرض الترتيب الفعلي بدلاً من "2" الثابتة
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              )
            else
              CircleAvatar(
                radius: 16,
                backgroundColor: colors.backgroundMain.withValues(alpha: 0.8), // متناسق مع الثيم
                child: Text(
                  visit.visitOrder.toString(), // الترتيب الفعلي للزيارات غير النشطة
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: isCompleted ? const Color(0xFF76F2D6) : colors.textSecondary.withValues(alpha: 0.2),
              ),
          ],
        ),
        const SizedBox(width: 15),
        // تفاصيل الزيارة والأزرار التفاعلية
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visit.pharmacyName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isActive
                              ? AppColors.primaryColor
                              : (isCompleted ? colors.textSecondary : colors.textDefault),
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitleText, // استخدام الـ subtitle الديناميكي الممرر الذي يحتوي على الـ ETA والترجمة
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textSecondary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
                // حالة الزيارة أو زر الإجراء
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F6F4),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "COMPLETED".tr,
                      style: const TextStyle(
                        color: Color(0xFF107064),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  )
                else if (isActive)
                // استبدل كود زر الماركة القديم داخل ملف DeliveryTimelineItem.dart بهذا الكود:
                  OutlinedButton(
                    onPressed: () async {
                      // 1. الانتقال والانتظار بشكل حتمي حتى تقفل الشاشة
                      final isSuccess = await Get.to(() => ConfirmDeliveryScreen(visit: visit));

                      // 2. إذا عادت بـ true نقوم بتحديث الكنترولر وتغيير الحالة فوراً
                      if (isSuccess == true) {
                        // استدعاء دالة التحديث بالمعرف الفعلي للزيارة
                        final mainController = Get.find<ActiveDeliveryRouteController>();
                        mainController.markVisitAsCompleted(visit.id);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: Text(
                      "MARK_DELIVERED".tr,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  )
                /*  OutlinedButton(
                    onPressed: () async {
                      // الانتقال لشاشة التأكيد والانتظار حتى يعود بنتيجة
                      final isSuccess = await Get.to(() => ConfirmDeliveryScreen(visit: visit));

                      // إذا رجع بنجاح، يتم إنهاء الطلب وتغيير الحالة فوراً
                      if (isSuccess == true) {
                        onMarkDelivered();
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: Text(
                      "MARK_DELIVERED".tr,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  )*/
              /*    OutlinedButton(
                    onPressed: onMarkDelivered,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: Text(
                      "MARK_DELIVERED".tr,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  )*/
                else
                  Icon(Icons.more_vert, color: colors.textSecondary.withValues(alpha: 0.6)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}