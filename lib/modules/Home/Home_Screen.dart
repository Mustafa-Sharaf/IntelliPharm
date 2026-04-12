import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/AppBarHome.dart';
import '../../Widgets/CustomBottomNav/CustomBottomNav.dart';
import '../../Widgets/CustomBottomNav/CustomBottomNavController.dart';
import '../../Widgets/MenuHome.dart';
import '../../app_theme/theme_extension.dart';
import '../AddOrder/AddOrder_Screen.dart';
import '../HomeContent/HomeContent_Screen.dart';
import '../MyOrders/FloatingAction.dart';
import '../MyOrders/MyOrders_Screen.dart';
import 'BuildAppBar.dart';

//New code
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final pages = [
    HomeContentScreen(),
    MyOrdersScreen(),
    Center(child: Text("ROUTE")),
    Center(child: Text("NOTES")),
    Center(child: Text("PROFILE")),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomBottomNavController());
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return Obx(
      () => Scaffold(
        key: scaffoldKey,
        backgroundColor: colors.backgroundMain,

        /// Drawer
        drawer: const DrawerHome(),

        /// AppBar
        appBar: _buildAppBar(controller.currentIndex.value, scaffoldKey),

        /// Change pages
        body: pages[controller.currentIndex.value],

        /// Navbar
        bottomNavigationBar: CustomBottomNav(
          currentIndex: controller.currentIndex.value,
          onTap: (index) {
            controller.changeIndex(index);
          },
        ),
        floatingActionButton: controller.currentIndex.value == 1
            ? FloatingAction(
                onPressed: () {
                  Get.to(AddOrderScreen());
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
) {
  switch (index) {
    case 0:
      return AppbarHome(scaffoldKey: scaffoldKey);

    case 1:
      return BuildAppbar(title: "My Orders");

    case 2:
      return AppBar(title: const Text("Route"));

    case 3:
      return AppBar(title: const Text("Notes"));

    case 4:
      return AppBar(title: const Text("Profile"));

    default:
      return null;
  }
}
