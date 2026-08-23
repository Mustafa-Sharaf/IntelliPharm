import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/DeliveryTimelineItem.dart';
import '../../Widgets/EmptyCard.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../../helper/mapHelper/dart/MapHelper_Screen.dart';
import '../ActiveOptimizedRouteTracking/CurrentRouteHeader.dart';
import '../ActiveOptimizedRouteTracking/PlanRouteCalculator.dart';
import 'ActiveDeliveryRoute_Controller.dart';
import 'ActivePharmacyCard.dart';

class ActiveDeliveryRouteScreen extends StatelessWidget {
  const ActiveDeliveryRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ActiveDeliveryRouteController>();
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Obx(() {
        final plan = controller.plan.value;

        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        if (plan == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: EmptyPlanCard(
                title: "No_Active_Plan".tr,
                subtitle: "AllDestinationsHaveBeenVisitedOrThereIsNoCurrentRoute".tr,
                buttonText: "CreatePlan".tr,
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          );
        }

        return Stack(
          children: [
            /// 1. Map View (Full Screen Background)
            Positioned.fill(
              child: MapHelperScreen(
                tag: "routeDelivery",
                refreshButtonBottom: size.height * 0.11,
                refreshButtonRight: size.height * 0.01,
                showRefreshButton: false,
                showMyLocationButton: false,
              ),
            ),

            /// 2. Top Floating Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CurrentRouteHeader(planRx: controller.plan),
            ),

            /// 3. Dynamic Bottom Sheet (Draggable & Expandable)
            DraggableScrollableSheet(
              initialChildSize: 0.55,
              minChildSize: 0.18,
              maxChildSize: 0.88,
              snap: true,
              snapSizes: const [0.18, 0.55, 0.88],
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: colors.backgroundMain,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.01,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Drag Handle Bar (المقبض)
                        Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),

                        /// Active Pharmacy Card Section
                        ActivePharmacyCard(
                          plan: plan,
                          controller: controller,
                        ),
                        SizedBox(height: size.height * 0.02),

                        /// Section Title
                        Text(
                          "DELIVERY_TIMELINE".tr,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colors.textSecondary,
                            fontFamily: 'Cairo',
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: size.height * 0.015),

                        /// Delivery Timeline Dynamic List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
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
                                          v.status != 'completed' &&
                                              v.visited != 1,
                                        );

                            final sharedPlan = plan.toPlanResponse();
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
                              isLast: index == plan.visits.length - 1,
                              subtitleText: subtitleText,
                              regionName: plan.regionName,
                              onMarkDelivered: () {
                                // Add your logic here
                              },
                            );
                          },
                        ),
                        SizedBox(height: size.height * 0.02),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}