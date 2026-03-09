import 'package:flutter/material.dart';
import 'AppColors.dart';


class AppThemes {
  static final lightTheme = ThemeData.light().copyWith(
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
      selectionColor: Colors.green.withOpacity(0.4),
      selectionHandleColor: Colors.green,
    ),
  );

  static final darkTheme = ThemeData.dark().copyWith(
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
      selectionColor: Colors.green.withOpacity(0.4),
      selectionHandleColor: Colors.green,
    ),

  );
}
