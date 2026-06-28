import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/AppBarHome.dart';
import '../../Widgets/CustomBottomNav/CustomBottomNav.dart';
import '../../Widgets/CustomBottomNav/CustomBottomNavController.dart';
import '../../Widgets/MenuHome.dart';
import '../../app_theme/theme_extension.dart';
import '../AddOrder/AddOrder_Screen.dart';
import '../AddPharmacy/AddPharmacy_Screen.dart';
import '../ChatGemini/ChatGemini_Screen.dart';
import '../HomeContent/HomeContent_Screen.dart';
import '../Pharmacists/Pharmacists_Screen.dart';
import 'FloatingAction.dart';
import '../MyOrders/MyOrders_Screen.dart';
import 'BuildAppBar.dart';

//New code
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final pages = [
    HomeContentScreen(),
    MyOrdersScreen(),
    ChatScreen(),
    Center(child: Text("NOTES")),
    //AddPharmacyScreen(),
    PharmacistsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomBottomNavController());
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    return Obx(
      () => Scaffold(
        key: scaffoldKey,
        backgroundColor: colors.backgroundMain,

        /// Drawer
        drawer: const DrawerHome(),

        /// AppBar
        appBar: _buildAppBar(controller.currentIndex.value, scaffoldKey, colors,size),

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
) {

  switch (index) {
    case 0:
      return AppbarHome(scaffoldKey: scaffoldKey);

    case 1:
      return BuildAppbar(title: "My Orders");

    case 2:
      return AppBar(
        backgroundColor: colors?.backgroundMain,
        elevation: 0,
        leading:  Icon(Icons.arrow_back, color:colors?.textPrimary),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
             SizedBox(width: size!.width * 0.03),
            Text(
              'IntelliPharma AI',
              style: TextStyle(
                color: colors?.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo'
              ),
            ),
          ],
        ),
      );

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
