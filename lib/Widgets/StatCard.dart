

//New code
import 'package:flutter/material.dart';

import '../app_theme/theme_extension.dart';
class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String title;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: size.width * 0.033,
        top: size.width * 0.029,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: colors.component,
          height: size.height * 0.14,
          width: size.width * 0.29,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: colors.textPrimary,
                size: size.height * 0.040,
              ),
              SizedBox(height:size.height * 0.007),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:colors.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
              // SizedBox(height: 5),
              Text(
                title,
                //maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: colors.textSecondary,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
