import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../../modules/PharmacyDetails/PharmacyDetailsBinding.dart';
import '../../modules/PharmacyDetails/PharmacyDetails_Screen.dart';
import 'ChangeStatusDialog.dart';
import 'RouteStepController.dart';

class RouteStepItem extends StatelessWidget {
  const RouteStepItem({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    this.isDone = false,
    this.isCurrent = false,
    this.showDetails = false,
    this.index,
    this.onDetailsPressed,
    this.showLine = true,
    this.onStartVisit,
    this.onStatusChange,
  });

  final int id;
  final String title;
  final String subtitle;
  final bool isDone;
  final bool isCurrent;
  final bool showDetails;
  final String? index;
  final VoidCallback? onDetailsPressed;
  final bool showLine;

  /// Callbacks للـ APIs
  final Future<void> Function(int visitId)? onStartVisit;
  final Future<void> Function(
    int visitId,
    String status,
    String cause,
    String? notes,
  )?
  onStatusChange;

  void _showChangeStatusDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => ChangeStatusDialog(
        onSubmit: (status, cause, notes) {
          if (onStatusChange != null) {
            onStatusChange!(id, status, cause, notes);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final routeStepController = Get.find<RouteStepController>();
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// STEP INDICATOR
          Column(
            children: [
              Container(
                width: size.width * 0.05,
                height: size.width * 0.05,
                decoration: BoxDecoration(
                  color: isDone
                      ? AppColors.primaryColor.withValues(alpha: 0.3)
                      : (isCurrent ? AppColors.primaryColor : Colors.grey[200]),
                  shape: BoxShape.circle,
                  border: isCurrent
                      ? null
                      : Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: isDone
                      ? Icon(
                          Icons.check,
                          size: 14,
                          color: AppColors.primaryColor,
                        )
                      : Text(
                          index ?? "",
                          style: TextStyle(
                            color: isCurrent ? Colors.white : Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                ),
              ),
              if (showLine)
                Expanded(
                  child: VerticalDivider(color: Colors.grey[300], thickness: 1),
                ),
            ],
          ),
          SizedBox(width: size.width * 0.03),

          /// CARD
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: size.height * 0.015),
              padding: EdgeInsets.all(size.height * 0.012),
              decoration: BoxDecoration(
                color: isCurrent ? colors.component : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: isCurrent
                    ? Border.all(color: Colors.grey.shade300)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE + ICON
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isDone ? Colors.grey : colors.textDefault,
                              fontFamily: 'Cairo',
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              decorationColor: Colors.grey,
                              decorationThickness: 2,
                            ),
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: 12,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => const PharmacyDetailsScreen(),
                            arguments: id,
                            binding: PharmacyDetailsBinding(),
                          );
                        },
                        child: Icon(
                          FontAwesomeIcons.squareArrowUpRight,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),

                  /// BUTTON DETAILS
                  if (showDetails) ...[
                    SizedBox(height: size.height * 0.012),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onDetailsPressed,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Visit_Details".tr,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),

                    /// ACTION BUTTONS (Start Visit & Status Change)
                    Row(
                      children: [
                        /// Button 1: Start Visit
                        Expanded(
                          child: Obx(
                            () => ElevatedButton.icon(
                              onPressed:
                                  routeStepController.isStartingVisit.value
                                  ? null
                                  : () => routeStepController.startVisit(id),
                              icon: routeStepController.isStartingVisit.value
                                  ? const SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(
                                      FontAwesomeIcons.play,
                                      size: 11,
                                      color: Colors.white,
                                    ),
                              label: Text(
                                "Start_of_visit".tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                disabledBackgroundColor: AppColors.primaryColor
                                    .withValues(alpha: 0.6),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: size.width * 0.06),

                        /// Button 2: Change Status
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showChangeStatusDialog(context),
                            icon: Icon(
                              FontAwesomeIcons.sliders,
                              size: 11,
                              color: colors.textDefault,
                            ),
                            label: Text(
                              "Change_status".tr,
                              style: TextStyle(
                                color: colors.textDefault,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
