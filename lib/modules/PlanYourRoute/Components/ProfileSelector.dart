import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../../app_theme/theme_extension.dart';
import '../PlanYourRoute_Controller.dart';

class ProfileSelector extends StatelessWidget {
  const ProfileSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final planYourRouteController = Get.find<PlanYourRouteController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header Title
        Text(
          "PROFILE".tr,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: colors.textSecondary,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: size.height * 0.01),

        /// Trigger Button
        Obx(() {
          final currentKey = planYourRouteController.selectedProfileKey.value;
          final hasSelection = currentKey != null;
          final currentSubtitle = hasSelection
              ? (planYourRouteController.profileSubtitles[currentKey] ?? '')
              : "Please_select_route_profile".tr;

          return GestureDetector(
            onTap: () => _showOptimizationBottomSheet(
              context,
              planYourRouteController,
              colors,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03,
                vertical: size.width * 0.03,
              ),
              decoration: BoxDecoration(
                color: colors.component,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: hasSelection
                          ? AppColors.primaryColor.withValues(alpha: 0.12)
                          : Colors.grey.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: hasSelection
                          ? AppColors.primaryColor
                          : Colors.grey,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: size.width * 0.025),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasSelection
                              ? currentKey.tr
                              : "Select_Optimization_Profile".tr,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            color: hasSelection
                                ? colors.textPrimary
                                : colors.textSecondary,
                          ),
                        ),
                        Text(
                          currentSubtitle.tr,
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'Cairo',
                            color: colors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: colors.textSecondary,
                    size: 24,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  /// BottomSheet Method
  void _showOptimizationBottomSheet(
      BuildContext context,
      PlanYourRouteController controller,
      ThemeColors colors,
      ) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Select_Optimization_Profile".tr,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Options List
            Flexible(
              child: SingleChildScrollView(
                child: Obx(() {
                  final selectedKey = controller.selectedProfileKey.value;
                  return Column(
                    children: controller.profileApiValues.keys.map((key) {
                      final isSelected = selectedKey == key;
                      final subtitle = controller.profileSubtitles[key] ?? '';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            controller.selectedProfileKey.value = key;
                            Get.back();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColor.withValues(alpha: 0.08)
                                  : colors.component,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : colors.textSecondary,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        key.tr,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? AppColors.primaryColor
                                              : colors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        subtitle.tr,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontFamily: 'Cairo',
                                          color: colors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}