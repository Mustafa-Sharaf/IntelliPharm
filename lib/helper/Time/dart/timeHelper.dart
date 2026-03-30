
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_theme/AppColors.dart';


class TimeHelper {


  static Future<TimeOfDay?> pickTime({
    required BuildContext context,
    required TimeOfDay? initialTime,
    required Color backgroundColor,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),

      builder: (context, child) {
        final isDark = Get.isDarkMode;

        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: backgroundColor,
              hourMinuteColor: AppColors.primaryColor,
              hourMinuteTextColor: AppColors.gray,
              dialHandColor: AppColors.primaryColor,
              entryModeIconColor: AppColors.primaryColor,
              dayPeriodTextColor: AppColors.gray,
              dayPeriodColor:
              isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
          ),
          child: child!,
        );
      },
    );

    return picked;
  }

  static String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
}