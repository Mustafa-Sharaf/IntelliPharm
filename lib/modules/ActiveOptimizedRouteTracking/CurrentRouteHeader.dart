import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../ActiveDeliveryRoute/ActiveDeliveryRoute_Controller.dart';
import '../ActiveDeliveryRoute/ActiveDeliveryRoute_Model.dart';
import '../ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Controller.dart';
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
                        height: 1.5,
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
                        padding: const EdgeInsets.only(top: 2.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: colors.textDefault.withValues(alpha: 0.6),
                              ),
                              SizedBox(width: size.width * 0.01),
                              Text(
                                'STOPS_COUNT'.trParams(
                                    {'count': plan.visits.length.toString()}),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colors.textDefault,
                                  fontSize: 13,
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
                                  fontSize: 13,
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
                                  fontSize: 13,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              ///  زر التبديل المشترك بين المندوب والموزع
              Obx(() {
                final bool isTrackingController = Get.isRegistered<ActiveOptimizedRouteTrackingController>();
                final bool isDeliveryController = Get.isRegistered<ActiveDeliveryRouteController>();

                bool isShowOnlyNextLeg = false;
                VoidCallback? onToggle;

                if (isTrackingController) {
                  final c = Get.find<ActiveOptimizedRouteTrackingController>();
                  isShowOnlyNextLeg = c.showOnlyNextLeg.value;
                  onToggle = c.toggleRouteMode;
                } else if (isDeliveryController) {
                  final c = Get.find<ActiveDeliveryRouteController>();
                  isShowOnlyNextLeg = c.showOnlyNextLeg.value;
                  onToggle = c.toggleRouteMode;
                }

                if (onToggle == null) return const SizedBox.shrink();

                return Container(
                  decoration: BoxDecoration(
                    color: isShowOnlyNextLeg
                        ? AppColors.primaryColor.withValues(alpha: 0.15)
                        : colors.backgroundMain,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    tooltip: isShowOnlyNextLeg
                        ? "Show_Full_Route".tr
                        : "Show_Next_Leg".tr,
                    onPressed: onToggle,
                    icon: Icon(
                      isShowOnlyNextLeg
                          ? Icons.navigation_rounded
                          : Icons.alt_route_rounded,
                      color: AppColors.primaryColor,
                      size: 22,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(Color? color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
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