

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';

class CurrentRouteHeader extends StatelessWidget {
  const CurrentRouteHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;

    final size = MediaQuery.of(context).size;
    return  SafeArea(
      child: Padding(
        padding: EdgeInsets.all(size.height * 0.01),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.height * 0.015,
            vertical: size.height * 0.01,
          ),
          decoration: BoxDecoration(
            color: colors.component,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              InkWell(
                borderRadius:
                BorderRadius.circular(10),
                onTap: () => Get.back(),
                child: Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CURRENT_ROUTE".tr,
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          letterSpacing: 2,
                          height: 2
                      ),
                    ),
                    Text(
                      "5 stops  •  2h 35m  •  28.4 km",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colors.textDefault,
                          fontSize: 16,
                          fontFamily: 'Cairo'
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                backgroundColor: AppColors.primaryColor,
                radius: 25,
                child: Icon(
                  Icons.person, size: 30, color: AppColors.white,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
