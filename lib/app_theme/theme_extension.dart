import 'package:flutter/material.dart';

class ThemeColors extends ThemeExtension<ThemeColors> {

  /// الخلفية الرئيسية
  final Color backgroundMain;

  /// خلفية ثانية لبعض الشاشات
  final Color backgroundSecondary;

  /// لون الكومبوننت (cards / containers)
  final Color component;

  /// لون النصوص
   final Color text;

  const ThemeColors({
    required this.backgroundMain,
    required this.backgroundSecondary,
    required this.component,
    required this.text,
  });

  @override
  ThemeColors copyWith({
    Color? backgroundMain,
    Color? backgroundSecondary,
    Color? component,
    Color? text,
  }) {
    return ThemeColors(
      backgroundMain: backgroundMain ?? this.backgroundMain,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      component: component ?? this.component,
      text: text ?? this.text
    );
  }

  @override
  ThemeColors lerp(ThemeExtension<ThemeColors>? other, double t) {
    if (other is! ThemeColors) return this;

    return ThemeColors(
      backgroundMain: Color.lerp(backgroundMain, other.backgroundMain, t)!,
      backgroundSecondary:
      Color.lerp(backgroundSecondary, other.backgroundSecondary, t)!,
      component: Color.lerp(component, other.component, t)!,
      text: Color.lerp(text,other.text,t)!,
    );
  }
}