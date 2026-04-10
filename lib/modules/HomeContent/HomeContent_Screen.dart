import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/PharmacyCard.dart';
import '../../Widgets/PlanRouteCard.dart';
import '../../Widgets/StatCard.dart';
import '../../app_theme/theme_extension.dart';

//New code
class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return SingleChildScrollView(
      child: Column(
        children: [
          PlanRouteCard(),
          Row(
            children: [
              StatCard(
                icon: Icons.verified_rounded,
                value: "33",
                title: "Visits".tr,
              ),
              StatCard(
                icon: Icons.handshake_rounded,
                value: "20",
                title: "Deals".tr,
              ),
              StatCard(
                icon: Icons.receipt_long_rounded,
                value: "15",
                title: "Order".tr,
              ),
            ],
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
          SizedBox(
            height: size.height * 0.49,
            child: ListView(
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
            ),
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
        ],
      ),
    );
  }
}
