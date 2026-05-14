


import 'package:flutter/material.dart';

import '../app_theme/theme_extension.dart';
import '../helper/DateHelper.dart';
class DateCard extends StatelessWidget {
  const DateCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    return  Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:  [
          Icon(Icons.chevron_left, color: Colors.grey),
          Column(
            children: [
              Text(
                "DELIVERY DATE",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'Cairo',
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: size.height * 0.004),
              Text(
                DateHelper.getFormattedDate(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Cairo',
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
