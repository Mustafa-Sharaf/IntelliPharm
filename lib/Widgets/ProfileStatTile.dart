import 'package:flutter/material.dart';
import '../../app_theme/theme_extension.dart';

class ProfileStatTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const ProfileStatTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size=MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.textPrimary, size: 22),
           SizedBox(height: size.height*0.01),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: colors.textSecondary,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: size.height*0.005),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}