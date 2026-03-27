import 'package:flutter/material.dart';
import '../app_theme/AppColors.dart';
import '../app_theme/theme_extension.dart';

class BuildSelector extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  const BuildSelector({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        decoration: BoxDecoration(
          color: colors.component, //Colors.grey[200]
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                value.isEmpty ? title : "$title: $value",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.gray,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
          ],
        ),
      ),
    );
  }
}
