import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/AppBarHome.dart';
import '../../Widgets/CustomBottomNav/CustomBottomNav.dart';
import '../../Widgets/CustomBottomNav/CustomBottomNavController.dart';
import '../../Widgets/MenuHome.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final pages = [
    Center(child: Text("HOME")),
    Center(child: Text("ORDERS")),
    Center(child: Text("ROUTE")),
    Center(child: Text("NOTES")),
    Center(child: Text("PROFILE")),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomBottomNavController());
    return Obx(() => Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xfff2f2f2),
      /// Drawer
      drawer: const DrawerHome(),
      /// AppBar
      appBar: controller.currentIndex.value == 0
          ? AppbarHome(scaffoldKey: scaffoldKey)
          : null,
      /// Change pages
      body: pages[controller.currentIndex.value],

      /// Navbar
      bottomNavigationBar: CustomBottomNav(
        currentIndex: controller.currentIndex.value,
        onTap: (index) {
          controller.changeIndex(index);
        },
      ),
    ));
  }
}
