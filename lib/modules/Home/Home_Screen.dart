import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/HomeCard.dart';
import '../../Widgets/HomeAppBar.dart';
import '../../Widgets/MenuHome.dart';
import '../../app_theme/theme_extension.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return Scaffold(
      backgroundColor: colors.backgroundMain,
      key: scaffoldKey,
      drawer: const DrawerHome(),
      appBar: HomeAppBar(
        height: MediaQuery.of(context).size.height * 0.15,
        scaffoldKey: scaffoldKey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            /// ---------------- Orders ----------------
            buildSection(
              title: "Order_Management".tr,
              children: [
                HomeCard(
                  icon: Icons.receipt_long,
                  title: "Add_Order".tr,
                  color: const Color(0xFF4CAF50),
                  onTap: () => Get.toNamed('/addOrderScreen'),
                ),
                HomeCard(
                  icon: Icons.list_alt,
                  title: "View_Orders".tr,
                  color: const Color(0xFF2152F3),
                  onTap: () => Get.toNamed('/viewOrdersScreen'),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),

            /// ---------------- Pharmacies ----------------
            buildSection(
              title: "Pharmacy_Management".tr,
              children: [
                HomeCard(
                  icon: Icons.add_business,
                  title: "Add_pharmacy".tr,
                  color: const Color(0xFFFF9800),
                  onTap: () => Get.toNamed('/addPharmacyScreen'),
                ),
                HomeCard(
                  icon: Icons.groups,
                  title: "Pharmacists".tr,
                  color: const Color(0xFF2196F3),
                  onTap: () => Get.toNamed('/pharmacistsScreen'),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),

            /// ---------------- Finance ----------------
            buildSection(
              title: "Financial_Management".tr,
              children: [
                HomeCard(
                  icon: Icons.account_balance_wallet,
                  title: "Pharmacist_debt_management".tr,
                  color: const Color(0xFF9C27B0),
                  onTap: () {},
                ),
                HomeCard(
                  icon: Icons.payments,
                  title: "My_Balance".tr,
                  color: const Color(0xFFF3C221),
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),

            /// ---------------- Routes ----------------
            buildSection(
              title: "ROUTES",
              children: [
                HomeCard(
                  icon: Icons.route,
                  title: "Track_the_route".tr,
                  color: const Color(0xFFF32133),
                  onTap: () => Get.toNamed('/trackRouteScreen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildSection({required String title, required List<Widget> children}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /// Title
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Cairo',
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Divider(color: Colors.grey, thickness: 0.5, height: 20),
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
        children: children,
      ),
    ],
  );
}

/*Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children:  [
            HomeCard(
              icon: Icons.receipt_long,
              title: "Add_Order".tr,
              color: const Color(0xFF4CAF50),
              onTap: () => Get.toNamed('/addOrderScreen'),
            ),
            HomeCard(
              icon: Icons.list_alt,
              title: "View_Orders".tr,
              color: const Color(0xFF2152F3),
              onTap: () => (),
            ),
            HomeCard(
              icon: Icons.add_business,
              title: "Add_pharmacy".tr,
              color: const Color(0xFFFF9800),
              onTap: () => Get.toNamed('/addPharmacyScreen'),
            ),
            HomeCard(
              icon: Icons.groups,
              title: "Pharmacists".tr,
              color: const Color(0xFF2196F3),
              onTap: () => Get.toNamed('/pharmacistsScreen'),
            ),
            HomeCard(
              icon: Icons.account_balance_wallet,
              title: "Pharmacist_debt_management".tr,
              color: const Color(0xFF9C27B0),//Color(0xFF9C27B0)
              onTap: () => (),
            ),
            HomeCard(
              icon: Icons.route,
              title: "Track_the_route".tr,
              color: const Color(0xFFF32133),
              onTap: () => (),
            ),
            HomeCard(
              icon: Icons.payments,
              title: "My_Balance".tr,
              color: const Color(0xFFF3C221),
              onTap: () => (),
            ),

          ],
        ),
      ),*/
