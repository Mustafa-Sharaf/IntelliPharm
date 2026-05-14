import 'package:flutter/material.dart';
import '../app_theme/theme_extension.dart';

class EmptyPlanCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback? onPressed;

  const EmptyPlanCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.3,
      padding: EdgeInsets.all(size.height * 0.02),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.height * 0.05,
            height: size.height * 0.05,
            decoration: BoxDecoration(
              color: colors.backgroundMain,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.calendar_today_outlined, size: 25),
          ),
          SizedBox(height: size.height * 0.014),

          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: size.height * 0.014),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Cairo',
              color: colors.textSecondary,
              height: 1.5,
            ),
          ),

          SizedBox(height: size.height * 0.014),

          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                color: Color(0xff0C8A7B),
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
