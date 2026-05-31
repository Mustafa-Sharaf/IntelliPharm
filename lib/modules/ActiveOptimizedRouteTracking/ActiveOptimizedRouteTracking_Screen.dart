import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/RouteStepItem.dart';
import '../../app_theme/theme_extension.dart';
import '../../helper/mapHelper/dart/MapHelper_Screen.dart';
import '../PlanYourRoute/PlanYourRoute_Controller.dart';
import 'ActiveOptimizedRouteTracking_Controller.dart';
import 'CurrentRouteHeader.dart';

class ActiveOptimizedRouteTrackingScreen extends StatelessWidget {
  const ActiveOptimizedRouteTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final controller = Get.put(ActiveOptimizedRouteTrackingController());
    final planYourRouteController = Get.find<PlanYourRouteController>();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                MapHelperScreen(
                  tag: "route",
                  refreshButtonBottom:
                      MediaQuery.of(context).size.height * 0.11,
                  refreshButtonRight: MediaQuery.of(context).size.height * 0.01,
                  showRefreshButton: true,
                ),
                CurrentRouteHeader(),
              ],
            ),
          ),

          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.backgroundMain,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(size.height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: size.height * 0.05,
                        height: size.height * 0.005,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.02),

                    /// Next Destination Section
                    Text(
                      "NEXT_DESTINATION".tr,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        letterSpacing: 2,
                        fontSize: 12,
                        height: 2,
                      ),
                    ),
                    Obx(() {
                      final plan = planYourRouteController.plan.value;
                      final nextVisit = controller.nextVisit;

                      if (plan == null || nextVisit == null) {
                        return const SizedBox();
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nextVisit.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                    color: colors.textDefault,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: size.width * 0.004),
                                    Text(
                                      "${plan.totalDurationHours} h",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.016),
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: size.width * 0.004),
                                    Text(
                                      "${plan.totalDistanceKm} km",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.navigation_outlined,
                              size: 18,
                            ),
                            label: Text(
                              "Navigate".tr,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 15,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    SizedBox(height: size.width * 0.06),
                    Text(
                      "ROUTE_SCHEDULE".tr,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: 'Cairo',
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: size.width * 0.04),
                    Obx(() {
                      if (planYourRouteController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final plan = planYourRouteController.plan.value;

                      if (plan == null) {
                        return const SizedBox();
                      }

                      return Column(
                        children: List.generate(plan.visits.length, (index) {
                          final visit = plan.visits[index];

                          return RouteStepItem(
                            title: visit.name,
                            subtitle: visit.info,
                            index: visit.visitOrder.toString(),
                            isCurrent: index == 0,
                            isDone: visit.visited,
                            showLine: index != plan.visits.length - 1,
                            showDetails: true,
                            onDetailsPressed: () {},
                          );
                        }),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
