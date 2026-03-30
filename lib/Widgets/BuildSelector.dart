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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4, top: 4),
        child: InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.component,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 17,
            ),
          ),

          child: Row(
            children: [
              Icon(icon, color: iconColor),
              SizedBox(width: MediaQuery.of(context).size.width * 0.04),
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
      ),
    );
  }
}
