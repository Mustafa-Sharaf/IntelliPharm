import 'package:flutter/material.dart';

class ColorClassHelper {
  Color getCardColor(String type, bool isDarkMode) {
    final String lowercaseType = type.toLowerCase();

    if (isDarkMode) {
      switch (lowercaseType) {
        case 'tip':
          return const Color(0xFF163331);
        case 'warning':
          return const Color(0xFF382920);
        default:
          return const Color(0xFF212934);
      }
    } else {
      switch (lowercaseType) {
        case 'tip':
          return const Color(0xFFCFF9F6);
        case 'warning':
          return const Color(0xFFFAEDE5);
        default:
          return Colors.white;
      }
    }
  }

  Color getTextColor(String type, bool isDarkMode) {
    final String lowercaseType = type.toLowerCase();

    if (isDarkMode) {
      switch (lowercaseType) {
        case 'tip':
          return const Color(0xFF64FFDA);
        case 'warning':
          return const Color(0xFFFFB74D);
        default:
          return const Color(0xFF94A3B8);
      }
    } else {
      switch (lowercaseType) {
        case 'tip':
          return const Color(0xFF00BFA5);
        case 'warning':
          return const Color(0xFFE67E22);
        default:
          return Colors.grey.shade600;
      }
    }
  }

  Color getTagColor(String type, bool isDarkMode) {
    final String lowercaseType = type.toLowerCase();
    if (isDarkMode) {
      switch (lowercaseType) {
        case 'tip':
          return const Color(0xFF64FFDA).withValues(alpha: 0.15);
        case 'warning':
          return const Color(0xFFFFB74D).withValues(alpha: 0.15);
        default:
          return Colors.grey.withValues(alpha: 0.15);
      }
    } else {
      switch (lowercaseType) {
        case 'tip':
          return const Color(0xFF64FFDA);
        case 'warning':
          return const Color(0xFFFEDBB7);
        default:
          return Colors.grey;
      }
    }
  }
}
