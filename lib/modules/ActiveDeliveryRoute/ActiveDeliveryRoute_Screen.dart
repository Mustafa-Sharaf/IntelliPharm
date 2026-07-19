import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Widgets/DeliveryTimelineItem.dart';
import '../../app_theme/theme_extension.dart';
import '../../helper/mapHelper/dart/MapHelper_Screen.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../ActiveOptimizedRouteTracking/CurrentRouteHeader.dart';
import '../ActiveOptimizedRouteTracking/PlanRouteCalculator.dart';
import 'ActiveDeliveryRoute_Controller.dart';
import 'ActivePharmacyCard.dart';

class ActiveDeliveryRouteScreen extends StatelessWidget {
  const ActiveDeliveryRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MapHelperController(), tag: "route");
    final controller = Get.find<ActiveDeliveryRouteController>();
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Obx(() {
        final plan = controller.plan.value;
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      MapHelperScreen(
                        tag: "route",
                        refreshButtonBottom: size.height * 0.11,
                        refreshButtonRight: size.height * 0.01,
                        showRefreshButton: false,
                        showMyLocationButton: false,
                      ),
                      CurrentRouteHeader(planRx: controller.plan),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colors.backgroundMain,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: plan == null
                        ? Center(
                            child: Text(
                              "NoCurrentDataPath".tr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                                color: colors.textSecondary,
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 12.0,
                                  bottom: 8.0,
                                ),
                                child: Container(
                                  width: 50,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.01),
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.05,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ActivePharmacyCard(
                                        plan: plan,
                                        controller: controller,
                                      ),
                                      SizedBox(height: size.height * 0.02),
                                      Text(
                                        "DELIVERY_TIMELINE".tr,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: colors.textSecondary,
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.015),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemCount: plan.visits.length,
                                        itemBuilder: (context, index) {
                                          final visit = plan.visits[index];
                                          final bool isCompleted =
                                              visit.status == 'completed' ||
                                              visit.visited == 1;
                                          final bool isActive =
                                              !isCompleted &&
                                              index ==
                                                  plan.visits.indexWhere(
                                                    (v) =>
                                                        v.status !=
                                                            'completed' &&
                                                        v.visited != 1,
                                                  );

                                          final sharedPlan = plan
                                              .toPlanResponse();
                                          String calculatedETA =
                                              PlanRouteCalculator.getETAForVisit(
                                                sharedPlan,
                                                index,
                                              );
                                          String subtitleText = isCompleted
                                              ? "VISITED_AT".trParams({
                                                  'time': calculatedETA,
                                                })
                                              : "ETA_TIME".trParams({
                                                  'time': calculatedETA,
                                                });

                                          return DeliveryTimelineItem(
                                            visit: visit,
                                            isCompleted: isCompleted,
                                            isActive: isActive,
                                            isLast:
                                                index == plan.visits.length - 1,
                                            subtitleText: subtitleText,
                                            onMarkDelivered: () {

                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
