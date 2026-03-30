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
              vertical: 8,
            ),
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
