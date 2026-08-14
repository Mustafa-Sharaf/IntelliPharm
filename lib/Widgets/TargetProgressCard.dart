import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import 'package:intl/intl.dart';
import '../../app_theme/theme_extension.dart';
import '../modules/Profile/Profile_Model.dart';


class TargetProgressCard extends StatelessWidget {
  final TargetStat target;
  final NumberFormat formatter;

  const TargetProgressCard({
    super.key,
    required this.target,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size=MediaQuery.of(context).size;
    final percentage = (target.progressPercentage * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${target.targetType.toUpperCase()} PROGRESS'.tr,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: colors.textSecondary,
              fontFamily: 'Cairo',
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height:size.height*0.005 ),

          Text(
            target.targetName.tr,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height:size.height*0.01 ),
          Row(
            children: [
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
              const Spacer(),
              Text(
                '${formatter.format(target.achievedValue)} ${'of'.tr} ${formatter.format(target.targetValue)} ${'achieved'.tr}',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textSecondary,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
           SizedBox(height: size.height*0.01),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: target.progressPercentage,
              minHeight: 6,
              backgroundColor: colors.backgroundMain,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}