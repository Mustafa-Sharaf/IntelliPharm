

import 'package:flutter/material.dart';
import '../app_theme/theme_extension.dart';
//New code
class OrderTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTap;

  const OrderTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return Row(
      children: List.generate(tabs.length, (index) {
        final isSelected = index == selectedIndex;

        return GestureDetector(
          onTap: () => onTap(index),
          child: Container(
            margin: EdgeInsets.only(right: size.width * 0.02),
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical:size.width * 0.02),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.teal
                  : colors.backgroundSecondary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tabs[index],
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }
}