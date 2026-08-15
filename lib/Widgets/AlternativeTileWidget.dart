import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../modules/MedicineDetails/MedicineDetails_Model.dart';


class AlternativeTileWidget extends StatelessWidget {
  final AlternativeMedicine alt;
  final NumberFormat formatter;

  const AlternativeTileWidget({
    super.key,
    required this.alt,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size=MediaQuery.of(context).size;
    final String currentLang = Get.locale?.languageCode ?? 'ar';

    return Container(
      margin: EdgeInsets.only(bottom: size.height*0.01),
      padding:  EdgeInsets.all(size.height*0.02),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.textSecondary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: size.height*0.05,
            height: size.height*0.05,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
              image: alt.images.isNotEmpty
                  ? DecorationImage(
                image: NetworkImage(alt.images.first),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: alt.images.isEmpty
                ? const Icon(
              Icons.medication_liquid,
              color: AppColors.primaryColor,
            )
                : null,
          ),
          SizedBox(width: size.width*0.025),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alt.commercialName.getName(currentLang),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                    fontFamily: 'Cairo',
                  ),
                ),
                if (alt.note.isNotEmpty)
                  Text(
                    "${'Note'.tr}: ${alt.note}",
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textSecondary,
                      fontFamily: 'Cairo',
                    ),
                  ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${formatter.format(alt.price)} ${'SP'.tr}",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                  fontFamily: 'Cairo',
                ),
              ),
               SizedBox(height: size.height*0.01),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: alt.isImported
                      ? Colors.orange.withValues(alpha: 0.1)
                      : Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  alt.isImported ? "Imported".tr : "Local".tr,
                  style: TextStyle(
                    fontSize: 10,
                    color: alt.isImported
                        ? Colors.red.shade800
                        : Colors.green.shade800,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}