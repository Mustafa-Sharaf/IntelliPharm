
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../Widgets/AppBarHome.dart';
import '../../Widgets/CustomBottomNav/CustomBottomNav.dart';
import '../../Widgets/CustomBottomNav/CustomBottomNavController.dart';
import '../../Widgets/MenuHome.dart';
import '../../app_theme/theme_extension.dart';
import '../AddOrder/AddOrder_Screen.dart';
import '../AddPharmacy/AddPharmacy_Screen.dart';
import '../ChatGemini/ChatGemini_Screen.dart';
import '../HomeContent/HomeContent_Screen.dart';
import '../HomeContentDistributor/HomeContentDistributor_Screen.dart';
import '../MyDeliveries/MyDeliveries_Screen.dart';
import '../Pharmacists/Pharmacists_Screen.dart';
import 'FloatingAction.dart';
import '../MyOrders/MyOrders_Screen.dart';
import 'BuildAppBar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final String role = GetStorage().read<String>('role') ?? 'rep';

  final repPages = [
    HomeContentScreen(),
    MyOrdersScreen(),
    ChatScreen(),
    const Center(child: Text("NOTES")),
    PharmacistsScreen(),
  ];

  final distributorPages = [
    HomeContentDistributorScreen(),
    MyDeliveriesScreen(),
    const Center(child: Text("Active Delivery Route")),
    const Center(child: Text("Deliveries History")),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomBottomNavController());
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final currentPages = role == 'distributor' ? distributorPages : repPages;

    return Obx(
      () => Scaffold(
        key: scaffoldKey,
        backgroundColor: colors.backgroundMain,
        //drawer: role == 'rep' ? const DrawerHome() : null,
        drawer: DrawerHome(),

        /// AppBar
        appBar: _buildAppBar(
          controller.currentIndex.value,
          scaffoldKey,
          colors,
          size,
          role,
        ),

        /// Body
        body: currentPages[controller.currentIndex.value],

        /// Navbar
        bottomNavigationBar: CustomBottomNav(
          currentIndex: controller.currentIndex.value,
          role: role,
          onTap: (index) {
            controller.changeIndex(index);
          },
        ),

        floatingActionButton:
            (role == 'rep' && controller.currentIndex.value == 1)
            ? FloatingAction(
                onPressed: () {
                  Get.to(() => AddOrderScreen());
                },
              )
            : null,
      ),
    );
  }
}


PreferredSizeWidget? _buildAppBar(
  int index,
  GlobalKey<ScaffoldState> scaffoldKey,
  ThemeColors? colors,
  Size? size,
  String role,
) {
  if (role == 'distributor') {
    switch (index) {
      case 0:
        return AppbarHome(scaffoldKey: scaffoldKey);
      case 1:
        return BuildAppbar(title: "My Deliveries");
      case 2:
        return BuildAppbar(title: "Active Route Progress");
      case 3:
        return BuildAppbar(title: "Delivery History");
      default:
        return null;
    }
  } else {
    switch (index) {
      case 0:
        return AppbarHome(scaffoldKey: scaffoldKey);
      case 1:
        return BuildAppbar(title: "My Orders");
      case 2:
        return null;
      case 3:
        return AppBar(title: const Text("Notes"));
      case 4:
        return BuildAppbar(
          title: "Pharmacists Screen",
          trailing: IconButton(
            icon: const Icon(Icons.add_business_rounded),
            onPressed: () {
              Get.to(() => AddPharmacyScreen());
            },
          ),
        );
      default:
        return null;
    }
  }
}
