import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/EmptyCard.dart';
import '../../Widgets/PharmacyCard.dart';
import '../../Widgets/PlanRouteCard.dart';
import '../../Widgets/StatCard.dart';
import '../../app_theme/theme_extension.dart';
import '../ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Screen.dart';
import '../PlanYourRoute/PlanYourRoute_Screen.dart';
import 'HomeContent_Controller.dart';


class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final homeContentController = Get.find<HomeContentController>();
    return SingleChildScrollView(
      child: Column(
        children: [
          PlanRouteCard(),
          Obx(
            () => Row(
              children: [
                StatCard(
                  icon: Icons.verified_rounded,
                  value: homeContentController.statistics.value?.visitsCount.toString() ?? "0",
                  title: "Visits".tr,
                ),
                StatCard(
                  icon: Icons.handshake_rounded,
                  value: homeContentController.statistics.value?.usefulVisitsCount.toString() ?? "0",
                  title: "Deals".tr,
                ),
                StatCard(
                  icon: Icons.receipt_long_rounded,
                  value: homeContentController.statistics.value?.ordersCount.toString() ?? "0",
                  title: "Order".tr,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size.width * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's_Visits".tr,
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: colors.textDefault,
                    fontFamily: 'Cairo',
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Get.to(()=>ActiveOptimizedRouteTrackingScreen());
                  },
                  child: Text(
                    "See_All".tr,
                    style: TextStyle(
                      fontSize: size.width * 0.04,
                      color: AppColors.primaryColor,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.49,
            child: Obx(() {
              if (homeContentController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }

              if (homeContentController.todayVisits.isEmpty) {
                return  Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: size.width * 0.033,
                    end: size.width * 0.029,
                  ),
                  child: Center(
                    child: EmptyPlanCard(
                      title: "NoVisitsPlannedYet".tr,
                      subtitle: "ThePharmaciesWillAppearHereOnceYouHaveSelectedTheAreaYouWillBeVisiting".tr,
                      buttonText: "CreatePlan".tr,
                      onPressed:(){
                        Get.to(PlanYourRouteScreen());
                      },
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: homeContentController.todayVisits.length,
                itemBuilder: (context, index) {
                  final visit = homeContentController.todayVisits[index];

                  return PharmacyCard(
                    name: visit.pharmacyName,
                    address: visit.planName,
                    time: visit.createdAt,
                    status: visit.visited
                        ? VisitStatus.visited
                        : VisitStatus.pending,
                  );
                },
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.all(size.width * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ActiveOffers",
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: colors.textDefault,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
