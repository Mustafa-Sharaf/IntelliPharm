

import 'package:flutter/material.dart';

class ColorClassHelper {

  Color getCardColor(String type) {
    switch (type.toLowerCase()) {
      case 'tip':
        return const Color(0xFFE0F7F4);
      case 'warning':
        return const Color(0xFFFDF2E9);
      default:
        return Colors.white;
    }
  }

  Color getTextColor(String type) {
    switch (type.toLowerCase()) {
      case 'tip':
        return const Color(0xFF00BFA5);
      case 'warning':
        return const Color(0xFFE67E22);
      default:
        return Colors.grey.shade600;
    }
  }

  Color getTagColor(String type) {
    switch (type.toLowerCase()) {
      case 'tip':
        return const Color(0xFF64FFDA);
      case 'warning':
        return const Color(0xFFFEDBB7);
      default:
        return const Color(0xFFEEEEEE);
    }
  }
}