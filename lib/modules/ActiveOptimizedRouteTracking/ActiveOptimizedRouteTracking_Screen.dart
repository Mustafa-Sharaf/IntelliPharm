import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/EmptyCard.dart';
import '../../Widgets/RouteStepItem/RouteStepController.dart';
import '../../Widgets/RouteStepItem/RouteStepItem.dart';
import '../../app_theme/theme_extension.dart';
import '../../helper/mapHelper/dart/MapHelper_Screen.dart';
import '../PlanYourRoute/PlanYourRoute_Controller.dart';
import '../VisitDetails/VisitDetailsBinding.dart';
import '../VisitDetails/VisitDetails_Screen.dart';
import 'ActiveOptimizedRouteTracking_Controller.dart';
import 'CurrentRouteHeader.dart';
import 'PlanRouteCalculator.dart';

class ActiveOptimizedRouteTrackingScreen extends StatelessWidget {
  const ActiveOptimizedRouteTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final controller = Get.find<ActiveOptimizedRouteTrackingController>();
    final planYourRouteController = Get.find<PlanYourRouteController>();
    final routeStepController = Get.find<RouteStepController>();

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }
        if (controller.plan == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: EmptyPlanCard(
                title: "No_Active_Plan".tr,
                subtitle: "AllDestinationsHaveBeenVisitedOrThereIsNoCurrentRoute".tr,
                buttonText: "CreatePlan".tr,
                onPressed: () {
                  Get.toNamed('/planYourRoute');
                },
              ),
            ),
          );
        }

        return Stack(
          children: [
            /// Map Background View
            Positioned.fill(
              child: MapHelperScreen(
                tag: "route",
                refreshButtonBottom: size.height * 0.11,
                refreshButtonRight: size.height * 0.01,
                showRefreshButton: false,
                showMyLocationButton: false,
              ),
            ),

            /// Top Floating Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CurrentRouteHeader(
                planRx: planYourRouteController.plan,
              ),
            ),
            ///Dynamic Bottom Sheet (Draggable & Expandable)
            DraggableScrollableSheet(
              initialChildSize: 0.55,
              minChildSize: 0.15,
              maxChildSize: 0.85,
              snap: true,
              snapSizes: const [0.15, 0.55, 0.85],
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
                      horizontal: size.height * 0.02,
                      vertical: size.height * 0.01,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///  Drag Handle Bar (المقبض التفاعلي)
                        Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            width: size.width * 0.12,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        /// Next Destination Section
                        Text(
                          "NEXT_DESTINATION".tr,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            height: 2,
                          ),
                        ),
                        Obx(() {
                          final plan = controller.plan;
                          final nextVisit = controller.nextVisit;
                          if (plan == null || nextVisit == null) {
                            return Center(
                              child: EmptyPlanCard(
                                title: "NoVisitsPlannedYet".tr,
                                subtitle:
                                "AllDestinationsHaveBeenVisitedOrThereIsNoCurrentRoute"
                                    .tr,
                                buttonText: "CreatePlan".tr,
                                onPressed: () {
                                  Get.toNamed('/planYourRoute');
                                },
                              ),
                            );
                          }
                          int nextVisitIndex = plan.visits.indexOf(nextVisit);
                          String nextVisitETA =
                          PlanRouteCalculator.getETAForVisit(
                            plan,
                            nextVisitIndex,
                          );
                          String nextVisitDistance =
                          PlanRouteCalculator.getFormatDistanceForVisit(
                            plan,
                            nextVisitIndex,
                          );
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
                                        fontSize: 16,
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
                                        SizedBox(width: size.width * 0.01),
                                        Text(
                                          nextVisitETA,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontFamily: 'Cairo',
                                          ),
                                        ),
                                        SizedBox(width: size.width * 0.03),
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        SizedBox(width: size.width * 0.01),
                                        Text(
                                          nextVisitDistance,
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
                                onPressed: () {
                                  controller.handleRePlan();
                                },
                                icon: const Icon(Icons.refresh, size: 18),
                                label: Text(
                                  "RePlan".tr,
                                  style: const TextStyle(
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
                        SizedBox(height: size.width * 0.03),
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

                        /// Route Schedule Dynamic List
                        Obx(() {
                          if (planYourRouteController.isLoading.value) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            );
                          }
                          final plan = planYourRouteController.plan.value;
                          if (plan == null) return const SizedBox();
                          return Column(
                            children: List.generate(plan.visits.length,
                                    (index) {
                                  final visit = plan.visits[index];
                                  String calculatedETA =
                                  PlanRouteCalculator.getETAForVisit(
                                      plan, index);
                                  String subtitleText = visit.visited
                                      ? "VISITED_AT"
                                      .trParams({'time': calculatedETA})
                                      : "ETA_TIME"
                                      .trParams({'time': calculatedETA});

                                  return RouteStepItem(
                                    id: visit.id,
                                    pharmacyId: visit.pharmacyId,
                                    title: visit.name,
                                    subtitle: subtitleText,
                                    index: visit.visitOrder.toString(),
                                    isCurrent: controller.nextVisit != null &&
                                        visit.pharmacyId ==
                                            controller.nextVisit!.pharmacyId,
                                    isDone: visit.visited,
                                    showLine: index != plan.visits.length - 1,
                                    showDetails: controller.nextVisit != null &&
                                        visit.pharmacyId ==
                                            controller.nextVisit!.pharmacyId,
                                    onDetailsPressed: () async {
                                      final bool? isChecked = await Get.to(
                                            () => const VisitDetailsScreen(),
                                        arguments: {
                                          "pharmacyId": visit.pharmacyId,
                                          "visitId": visit.id,
                                        },
                                        binding: VisitDetailsBinding(),
                                      );
                                      if (isChecked == true) {
                                        await controller.refreshTrackingData();
                                      }
                                    },
                                    onStartVisit: (visitId) async {
                                      await routeStepController
                                          .startVisit(visitId);
                                    },
                                    onStatusChange:
                                        (visitId, status, cause, notes) async {
                                      await routeStepController.updateVisitStatus(
                                        visitId,
                                        status,
                                        cause,
                                        notes: notes,
                                      );

                                    },
                                  );
                                }),
                          );
                        }),
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