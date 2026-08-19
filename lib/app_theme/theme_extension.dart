import 'package:flutter/material.dart';

class ThemeColors extends ThemeExtension<ThemeColors> {

  final Color backgroundMain;
  final Color backgroundSecondary;
  final Color component;


  final Color textPrimary;
  final Color textSecondary;
  final Color textDefault;

  const ThemeColors({
    required this.backgroundMain,
    required this.backgroundSecondary,
    required this.component,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDefault,
  });

  @override
  ThemeColors copyWith({
    Color? backgroundMain,
    Color? backgroundSecondary,
    Color? component,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDefault,
  }) {
    return ThemeColors(
      backgroundMain: backgroundMain ?? this.backgroundMain,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      component: component ?? this.component,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDefault: textDefault ?? this.textDefault,
    );
  }

  @override
  ThemeColors lerp(ThemeExtension<ThemeColors>? other, double t) {
    if (other is! ThemeColors) return this;

    return ThemeColors(
      backgroundMain: Color.lerp(backgroundMain, other.backgroundMain, t)!,
      backgroundSecondary: Color.lerp(backgroundSecondary, other.backgroundSecondary, t)!,
      component: Color.lerp(component, other.component, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDefault: Color.lerp(textDefault, other.textDefault, t)!,
    );
  }
}