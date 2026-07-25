
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/theme_extension.dart';
import 'NavItem.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final String role;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final currentItems = role == 'distributor' ? distributorItems : repItems;

    return Container(
      height: (height * 0.08) + bottomPadding,
      padding: EdgeInsets.only(
        left: height * 0.008,
        right: height * 0.008,
        bottom: bottomPadding, // رفع المحتوى للأعلى بمقدار مساحة أزرار النظام
      ),
      decoration: BoxDecoration(
        color: colors.backgroundMain,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, -2),
            color: Colors.black.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: Row(
        children: List.generate(currentItems.length, (index) {
          final item = currentItems[index];
          final isSelected = currentIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                margin: EdgeInsets.symmetric(vertical: height * 0.008, horizontal: height * 0.004),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xff0C8A7B).withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedScale(
                      scale: isSelected ? 1.15 : 1,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        item.icon,
                        color: isSelected ? const Color(0xff0C8A7B) : Colors.grey,
                        size: height * 0.03,
                      ),
                    ),
                    SizedBox(height: height * 0.002),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: isSelected ? 11 : 10,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                        color: isSelected ? const Color(0xff0C8A7B) : Colors.grey,
                      ),
                      child: Text(item.label.tr),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
