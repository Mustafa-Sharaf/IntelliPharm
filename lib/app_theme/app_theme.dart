
import 'package:flutter/material.dart';
import 'package:intellipharm/app_theme/theme_extension.dart';
import 'AppColors.dart';


class AppThemes {

  /// LIGHT THEME
  /// Use the default Light theme and then modify it using copyWith
  static final lightTheme = ThemeData.light().copyWith(

    scaffoldBackgroundColor: AppColors.backgroundColorLight,

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
      selectionColor: Colors.green.withValues(alpha: 0.4),
      selectionHandleColor: AppColors.primaryColor,
    ),

    extensions: const [

      ThemeColors(
        backgroundMain: AppColors.backgroundColorLight,
        backgroundSecondary: AppColors.white,
        component: Colors.white,
        text: Colors.black,
      ),

    ],
  );

  /// DARK THEME
  static final darkTheme = ThemeData.dark().copyWith(

    scaffoldBackgroundColor: AppColors.backgroundDark,

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
      selectionColor: Colors.green.withValues(alpha: 0.4),
      selectionHandleColor: AppColors.primaryColor,
    ),

    extensions: const [

      ThemeColors(
        backgroundMain: AppColors.backgroundDark,
        backgroundSecondary: Color(0xFF1B1B1B),
        component: AppColors.componentDark,
        text: Colors.white,
      ),

    ],
  );
}