/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../PlanYourRoute/PlanYourRoute_Controller.dart';
import 'PlanRouteCalculator.dart';

class CurrentRouteHeader extends StatelessWidget {

  const CurrentRouteHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final planYourRouteController = Get.find<PlanYourRouteController>();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
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
                borderRadius: BorderRadius.circular(10),
                onTap: () => Get.back(),
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
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
                        height: 2,
                      ),
                    ),

                    Obx(() {
                      final plan = planYourRouteController.plan.value;
                      if (plan == null) {
                        return Text(
                          "LoadingRoute".tr,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: colors.textSecondary,
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: colors.textDefault.withValues(alpha: 0.6),
                            ),
                            SizedBox(width: size.width * 0.01),
                            Text(
                              'STOPS_COUNT'.trParams({'count': plan.visits.length.toString()}),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.textDefault,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            _buildDivider(colors.textDefault),
                            Icon(
                              Icons.route,
                              size: 16,
                              color: colors.textDefault.withValues(alpha: 0.6),
                            ),
                            SizedBox(width: size.width * 0.01),
                            Text(
                              PlanRouteCalculator.formattedTotalDistance(plan),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.textDefault,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            _buildDivider(colors.textDefault),
                            Icon(
                              Icons.access_time_rounded,
                              size: 16,
                              color: colors.textDefault.withValues(alpha: 0.6),
                            ),
                            SizedBox(width: size.width * 0.01),
                            Text(
                              PlanRouteCalculator.formattedTotalDuration(plan),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.textDefault,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              CircleAvatar(
                backgroundColor: AppColors.primaryColor,
                radius: 25,
                child: Icon(Icons.person, size: 30, color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(Color? color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        "•",
        style: TextStyle(
          color: color?.withValues(alpha: 0.6),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
*//*

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
// قم باستيراد موديل الـ Plan الخاص بك هنا (مثلاً: import '../../models/plan.dart';)
import 'PlanRouteCalculator.dart';

class CurrentRouteHeader extends StatelessWidget {
  // 1. نقوم بتعريف الـ plan كـ Rxn (أو Rx قابلة للكون نال) ممررة من الخارج
  final Rxn<dynamic> planRx; // استبدل dynamic بنوع الموديل الخاص بك، مثلاً Rxn<Plan>

  const CurrentRouteHeader({
    super.key,
    required this.planRx, // نجعلها مطلوبة عند استدعاء الـ Widget
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
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
                borderRadius: BorderRadius.circular(10),
                onTap: () => Get.back(),
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
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
                        height: 2,
                      ),
                    ),

                    // 2. الـ Obx هنا تراقب الـ planRx الممررة للـ Widget
                    Obx(() {
                      final plan = planRx.value;
                      if (plan == null) {
                        return Text(
                          "LoadingRoute".tr,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: colors.textSecondary,
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: colors.textDefault.withValues(alpha: 0.6),
                            ),
                            SizedBox(width: size.width * 0.01),
                            Text(
                              'STOPS_COUNT'.trParams({'count': plan.visits.length.toString()}),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.textDefault,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            _buildDivider(colors.textDefault),
                            Icon(
                              Icons.route,
                              size: 16,
                              color: colors.textDefault.withValues(alpha: 0.6),
                            ),
                            SizedBox(width: size.width * 0.01),
                            Text(
                              PlanRouteCalculator.formattedTotalDistance(plan),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.textDefault,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            _buildDivider(colors.textDefault),
                            Icon(
                              Icons.access_time_rounded,
                              size: 16,
                              color: colors.textDefault.withValues(alpha: 0.6),
                            ),
                            SizedBox(width: size.width * 0.01),
                            Text(
                              PlanRouteCalculator.formattedTotalDuration(plan),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.textDefault,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              CircleAvatar(
                backgroundColor: AppColors.primaryColor,
                radius: 25,
                child: Icon(Icons.person, size: 30, color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(Color? color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        "•",
        style: TextStyle(
          color: color?.withValues(alpha: 0.6),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../ActiveDeliveryRoute/ActiveDeliveryRoute_Model.dart';
import 'PlanRouteCalculator.dart';

class CurrentRouteHeader extends StatelessWidget {
  final Rxn<dynamic> planRx;
  const CurrentRouteHeader({
    super.key,
    required this.planRx,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
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
                borderRadius: BorderRadius.circular(10),
                onTap: () => Get.back(),
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
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
                        height: 2,
                      ),
                    ),

                    Obx(() {
                      final rawPlan = planRx.value;
                      if (rawPlan == null) {
                        return Text(
                          "LoadingRoute".tr,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: colors.textSecondary,
                          ),
                        );
                      }


                      final plan = (rawPlan is DeliveryPlan)
                          ? rawPlan.toPlanResponse()
                          : rawPlan;

                      return Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: colors.textDefault.withValues(alpha: 0.6),
                            ),
                            SizedBox(width: size.width * 0.01),
                            Text(
                              'STOPS_COUNT'.trParams({'count': plan.visits.length.toString()}),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.textDefault,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            _buildDivider(colors.textDefault),
                            Icon(
                              Icons.route,
                              size: 16,
                              color: colors.textDefault.withValues(alpha: 0.6),
                            ),
                            SizedBox(width: size.width * 0.01),
                            Text(
                              PlanRouteCalculator.formattedTotalDistance(plan),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.textDefault,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            _buildDivider(colors.textDefault),
                            Icon(
                              Icons.access_time_rounded,
                              size: 16,
                              color: colors.textDefault.withValues(alpha: 0.6),
                            ),
                            SizedBox(width: size.width * 0.01),
                            Text(
                              PlanRouteCalculator.formattedTotalDuration(plan),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.textDefault,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              CircleAvatar(
                backgroundColor: AppColors.primaryColor,
                radius: 25,
                child: Icon(Icons.person, size: 30, color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(Color? color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        "•",
        style: TextStyle(
          color: color?.withValues(alpha: 0.6),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}