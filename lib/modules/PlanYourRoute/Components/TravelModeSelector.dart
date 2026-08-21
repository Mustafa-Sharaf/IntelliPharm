import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../../app_theme/theme_extension.dart';
import '../PlanYourRoute_Controller.dart';

class TravelModeSelector extends StatelessWidget {
  TravelModeSelector({super.key});

  final List<String> types = ["Walking", "Driving"];

  final Map<String, IconData> typeIcons = {
    "Walking": Icons.directions_walk,
    "Driving": Icons.directions_car,
  };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final planYourRouteController = Get.find<PlanYourRouteController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
        Text(
          "TRAVEL_MODE".tr,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: colors.textSecondary,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: size.height * 0.01),

        /// Selector Options
        Obx(
          () => Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: colors.component,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: types.map((type) {
                final isSelected =
                    planYourRouteController.selectedType.value == type;

                return Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        planYourRouteController.selectedType.value = type,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          textDirection: Directionality.of(context),
                          children: [
                            Icon(
                              typeIcons[type],
                              color: isSelected ? Colors.white : AppColors.gray,
                              size: 20,
                            ),
                            SizedBox(width: size.width * 0.008),
                            Text(
                              type.tr,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
