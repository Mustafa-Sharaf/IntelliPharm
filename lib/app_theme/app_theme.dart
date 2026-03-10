/*import 'package:flutter/material.dart';
import 'AppColors.dart';


class AppThemes {
  static final lightTheme = ThemeData.light().copyWith(
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
      selectionColor: Colors.green.withValues(alpha: 0.4),
      selectionHandleColor: Colors.green,
    ),
  );

  static final darkTheme = ThemeData.dark().copyWith(
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
      selectionColor: Colors.green.withValues(alpha: 0.4),
      selectionHandleColor: Colors.green,
    ),

  );
}*/
import 'package:flutter/material.dart';
import 'package:intellipharm/app_theme/theme_extension.dart';
import 'AppColors.dart';


class AppThemes {

  /// LIGHT THEME
  static final lightTheme = ThemeData.light().copyWith(

    scaffoldBackgroundColor: AppColors.backgroundColorLight1,

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
      selectionColor: Colors.green.withValues(alpha: 0.4),
      selectionHandleColor: Colors.green,
    ),

    extensions: const [

      ThemeColors(
        backgroundMain: AppColors.backgroundColorLight1,
        backgroundSecondary: AppColors.backgroundColorLight2,
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
      selectionHandleColor: Colors.green,
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