
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
            textTheme: const TextTheme(
              bodyMedium: TextStyle(fontFamily: 'Cairo'),
              bodyLarge: TextStyle(fontFamily: 'Cairo'),
              labelLarge: TextStyle(fontFamily: 'Cairo'),
              labelMedium: TextStyle(fontFamily: 'Cairo'),
              labelSmall: TextStyle(fontFamily: 'Cairo'),
            ),


            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                textStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),

            timePickerTheme: TimePickerThemeData(
              backgroundColor: backgroundColor,
              hourMinuteColor: AppColors.primaryColor,
              hourMinuteTextColor: AppColors.gray,
              dialHandColor: AppColors.primaryColor,
              entryModeIconColor: AppColors.primaryColor,
              dayPeriodTextColor: AppColors.gray,
              dayPeriodColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              hourMinuteTextStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 40, fontWeight: FontWeight.bold),
              dayPeriodTextStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold),
              helpTextStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
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