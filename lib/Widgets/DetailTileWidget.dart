import 'package:flutter/material.dart';
import '../../app_theme/theme_extension.dart';

class DetailTileWidget extends StatelessWidget {
  final String title;
  final String value;

  const DetailTileWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size=MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(size.height*0.02),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              color: colors.textSecondary,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
           SizedBox(height: size.height*0.01),
          FittedBox(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }
}