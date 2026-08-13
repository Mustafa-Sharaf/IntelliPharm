import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../app_theme/theme_extension.dart';
import '../modules/PharmacyDebts/PharmacyDebt_Controller.dart';

class BuildFilterChipsDebts extends StatelessWidget {
  const BuildFilterChipsDebts({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PharmacyDebtController>();
    final size = MediaQuery.of(context).size;

    final filters = ['All', 'Fully Paid', 'Partially Paid', 'Pending', 'Overdue'];
    final Map<String, String> filterTranslations = {
      'All': 'filter_all'.tr,
      'Fully Paid': 'filter_fully_paid'.tr,
      'Partially Paid': 'filter_partially_paid'.tr,
      'Pending': 'filter_pending'.tr,
      'Overdue': 'filter_overdue'.tr,
    };

    final colors = Theme.of(context).extension<ThemeColors>()!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ValueListenableBuilder<String>(
        valueListenable: controller.selectedFilterNotifier,
        builder: (context, selectedFilter, _) {
          return Row(
            children: filters.map((filter) {
              final isSelected = selectedFilter == filter;
              final isOverdueBtn = filter == 'Overdue';
              Color bgColor = colors.textSecondary.withValues(alpha: 0.2);
              Color textColor = colors.textDefault;
              Border? border;

              if (isSelected) {
                if (isOverdueBtn) {
                  bgColor = Colors.red;
                  textColor = Colors.white;
                  border = Border.all(color: Colors.red);
                } else {
                  bgColor = AppColors.primaryColor;
                  textColor = Colors.white;
                }
              } else if (isOverdueBtn) {
                textColor = Colors.red;
                border = Border.all(color: Colors.red);
                bgColor = Colors.red.withValues(alpha: 0.02);
              }

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () => controller.filterByStatus(filter),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03,
                      vertical: size.width * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(20),
                      border: border,
                    ),
                    child: Text(
                      filterTranslations[filter] ?? filter,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}