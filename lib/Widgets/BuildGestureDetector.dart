import 'package:flutter/material.dart';
import '../app_theme/AppColors.dart';
import '../app_theme/theme_extension.dart';

class BuildGestureDetector extends StatelessWidget {
  const BuildGestureDetector({
    super.key,
    this.onTap,
    required this.text,
    this.icon,
  });

  final VoidCallback? onTap;
  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.component,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primaryColor),
              SizedBox(height: MediaQuery.of(context).size.height * 0.001),
              Text(
                text,
                style: TextStyle(color: AppColors.gray, fontFamily: 'Cairo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
