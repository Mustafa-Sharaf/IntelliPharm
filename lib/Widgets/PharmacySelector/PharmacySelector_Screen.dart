import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import 'PharmacyBottomSheet.dart';
import 'PharmacyList_Controller.dart';
import 'PharmacySelector_Model.dart';

class PharmacySelectorWidget extends StatelessWidget {
  final Function(PharmacyModel pharmacy)? onSelected;

  PharmacySelectorWidget({super.key, this.onSelected});

  final controller = Get.find<PharmacySelectorController>();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return Obx(() {
      final pharmacy = controller.selectedPharmacy.value;

      return InkWell(
        onTap: () {
          Get.bottomSheet(
            PharmacyBottomSheet(onSelected: onSelected),
            isScrollControlled: true,
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.03,
            vertical: size.width * 0.03,
          ),
          decoration: BoxDecoration(
            color: colors.component,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: size.width * 0.1,
                height: size.width * 0.1,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on,
                  color: AppColors.primaryColor,
                  size: size.width * 0.07,
                ),
              ),

               SizedBox(width: size.width * 0.02),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pharmacy?.name ?? "SelectPharmacy".tr,
                      style:  TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        color: colors.textPrimary,
                        fontSize: size.width * 0.04,
                      ),
                    ),
                    Text(
                      pharmacy?.region ?? "Region".tr,
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontFamily: 'Cairo',
                        fontSize: size.width * 0.03,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: colors.textSecondary,
              ),
            ],
          ),
        ),
      );
    });
  }
}
