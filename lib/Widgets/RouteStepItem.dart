import 'package:flutter/material.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../app_theme/theme_extension.dart';

class RouteStepItem extends StatelessWidget {
  const RouteStepItem({
    super.key,
    required this.title,
    required this.subtitle,
    this.isDone = false,
    this.isCurrent = false,
    this.showDetails = false,
    this.index,
    this.onDetailsPressed,
    this.showLine = true,
  });

  final String title;
  final String subtitle;
  final bool isDone;
  final bool isCurrent;
  final bool showDetails;
  final String? index;
  final VoidCallback? onDetailsPressed;
  final bool showLine;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// STEP INDICATOR
          Column(
            children: [
              Container(
                width: size.width * 0.05,
                height: size.width * 0.05,
                decoration: BoxDecoration(
                  color: isDone
                      ? AppColors.primaryColor.withValues(alpha: 0.3)
                      : (isCurrent ? AppColors.primaryColor : Colors.grey[200]),
                  shape: BoxShape.circle,
                  border: isCurrent
                      ? null
                      : Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: isDone
                      ? Icon(
                          Icons.check,
                          size: 14,
                          color: AppColors.primaryColor,
                        )
                      : Text(
                          index ?? "",
                          style: TextStyle(
                            color: isCurrent ? Colors.white : Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                ),
              ),
              if (showLine)
                Expanded(
                  child: VerticalDivider(color: Colors.grey[300], thickness: 1),
                ),
            ],
          ),
          SizedBox(width: size.width * 0.03),

          /// CARD
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: size.height * 0.015),
              padding: EdgeInsets.all(size.height * 0.012),
              decoration: BoxDecoration(
                color: isCurrent ? colors.component : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: isCurrent
                    ? Border.all(color: Colors.grey.shade300)
                    : null,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE + ICON
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isDone ? Colors.grey : colors.textDefault,
                              fontFamily: 'Cairo',

                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,

                              decorationColor: Colors.grey,
                              decorationThickness: 2,
                            ),
                          ),

                          Text(
                            subtitle,
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: 12,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),

                      Icon(Icons.drag_indicator, color: Colors.grey[400]),
                    ],
                  ),

                  /// BUTTON
                  if (showDetails) ...[
                    SizedBox(height: size.height * 0.012),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onDetailsPressed,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "View Details",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
