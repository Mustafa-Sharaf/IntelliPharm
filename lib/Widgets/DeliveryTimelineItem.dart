import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final String regionName;

  const DeliveryTimelineItem({
    super.key,
    required this.visit,
    required this.isCompleted,
    required this.isActive,
    required this.isLast,
    required this.subtitleText,
    required this.onMarkDelivered,
    required this.regionName,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size=MediaQuery.of(context).size;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                backgroundColor: AppColors.primaryColor,
                child: Text(
                  visit.visitOrder.toString(),
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
                backgroundColor: colors.textSecondary.withValues(alpha: 0.5),
                child: Text(
                  visit.visitOrder.toString(),
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            if (!isLast)
              Container(
                width: size.width * 0.004,
                height: size.height * .06,
                color: isCompleted
                    ? const Color(0xFF76F2D6)
                    : colors.textSecondary.withValues(alpha: 0.2),
              ),
          ],
        ),
         SizedBox(width: size.width * 0.02),
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
                          decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                          color: isActive
                              ? AppColors.primaryColor
                              : (isCompleted
                              ? colors.textSecondary
                              : colors.textDefault),
                          fontFamily: 'Cairo',
                        ),
                      ),
                       SizedBox(height: size.height * 0.02),
                      Text(
                        subtitleText,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textSecondary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
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
                  OutlinedButton(
                    onPressed: () async {
                      final isSuccess = await /*Get.to(
                        () => ConfirmDeliveryScreen(
                          visit: visit,
                          regionName: regionName,
                        ),
                      );*/
                      Get.toNamed(
                        '/confirmDelivery',
                        arguments: {
                          'visit': visit,
                          'regionName': regionName,
                        },
                      );
                      if (isSuccess == true) {
                        final mainController =
                            Get.find<ActiveDeliveryRouteController>();
                        mainController.markVisitAsCompleted(visit.id);
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
                      "DeliveryConfirmation".tr,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  )
                else
                  Icon(
                    FontAwesomeIcons.squareArrowUpRight,
                    color: colors.textSecondary.withValues(alpha: 0.6),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
