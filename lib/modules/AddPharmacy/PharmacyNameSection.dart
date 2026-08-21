
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import 'AddPharmacy_Controller.dart';

class PharmacyNameSection extends StatelessWidget {
  const PharmacyNameSection({super.key,
  });



  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final addPharmacyController = Get.find<AddPharmacyController>();
    return Container(
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name(English)'.tr,
            style: TextStyle(
              fontSize: 12,
              color: colors.textSecondary,
              fontWeight: FontWeight.w500,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: size.height * 0.008),
          TextFormField(
            controller: addPharmacyController.nameEnController,
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.translate,
                size: 20,
                color: AppColors.primaryColor,
              ),
              suffixIcon: Icon(
                Icons.check_circle,
                color: AppColors.primaryColor,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: size.width * 0.012,
                vertical: size.width * 0.01,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFCFD8DC)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primaryColor),
              ),
            ),
            validator: (value) =>
                value!.isEmpty ? 'This_field_is_required'.tr : null,
          ),
          SizedBox(height: size.width * 0.02),

          Text(
            'Name(Arabic)'.tr,
            style: TextStyle(
              fontSize: 12,
              color: colors.textSecondary,
              fontWeight: FontWeight.w500,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: size.width * 0.01),
          TextFormField(
            controller: addPharmacyController.nameArController,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: 'Enter_the_name_of_the_pharmacy_in_Arabic'.tr,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
                fontFamily: 'Cairo',
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              fillColor: colors.backgroundMain,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) => value!.isEmpty ? 'This_field_is_required'.tr : null,
          ),
          SizedBox(height: size.width * 0.01),
          Text(
            'Arabic_characters_only'.tr,
            style: TextStyle(
              fontSize: 12,
              color: colors.textSecondary,
              fontWeight: FontWeight.w500,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
