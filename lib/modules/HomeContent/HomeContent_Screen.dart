import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/EmptyCard.dart';
import '../../Widgets/PharmacyCard.dart';
import '../../Widgets/PlanRouteCard.dart';
import '../../Widgets/StatCard.dart';
import '../../app_theme/theme_extension.dart';
import '../PlanYourRoute/PlanYourRoute_Screen.dart';
import '../VisitDetails/VisitDetails_Screen.dart';
import 'HomeContent_Controller.dart';

//New code
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
                  value:
                      homeContentController.statistics.value?.visitsCount
                          .toString() ??
                      "0",
                  title: "Visits".tr,
                ),
                StatCard(
                  icon: Icons.handshake_rounded,
                  value:
                      homeContentController.statistics.value?.usefulVisitsCount
                          .toString() ??
                      "0",
                  title: "Deals".tr,
                ),
                StatCard(
                  icon: Icons.receipt_long_rounded,
                  value:
                      homeContentController.statistics.value?.ordersCount
                          .toString() ??
                      "0",
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
                Text(
                  "See_All".tr,
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    color: Color(0xff016E65),
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          /* SizedBox(
            height: size.height * 0.49,
            child: Obx(
              () => ListView.builder(
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
              ),
            ),
          ),*/
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
                return  Center(
                  child: EmptyPlanCard(
                    title: "No visits planned yet.",
                    subtitle: "The pharmacies will appear here once you have selected the area you will be visiting.",
                    buttonText: "Create Plan",
                    onPressed:(){
                      Get.to(PlanYourRouteScreen());
                    },
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
                  "Active Offers",
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

          GestureDetector(
            onTap: () => Get.to(() => VisitDetailsScreen(id: 390)),
            child: const Text(
              "Test",
              style: TextStyle(fontSize: 30),
            ),
          )
        ],
      ),
    );
  }
}

/*ListView(
              children: [
                PharmacyCard(
                  name: "Apex Pharmacy",
                  address: "123 Health St, Damascus",
                  time: "10:30 AM",
                  status: VisitStatus.pending,
                ),

                PharmacyCard(
                  name: "MedLife Care",
                  address: "77 Central Plaza, Damascus",
                  time: "09:15 AM",
                  status: VisitStatus.visited,
                ),
                PharmacyCard(
                  name: "Apex Pharmacy",
                  address: "123 Health St, Damascus",
                  time: "10:30 AM",
                  status: VisitStatus.pending,
                ),
                PharmacyCard(
                  name: "Al-Nattour Pharmacy",
                  address: "al-midan, Damascus",
                  time: "09:15 AM",
                  status: VisitStatus.visited,
                ),
                PharmacyCard(
                  name: "Apex Pharmacy",
                  address: "123 Health St, Damascus",
                  time: "10:30 AM",
                  status: VisitStatus.pending,
                ),
                PharmacyCard(
                  name: "Apex Pharmacy",
                  address: "123 Health St, Damascus",
                  time: "10:30 AM",
                  status: VisitStatus.pending,
                ),
              ],
            ),*/
