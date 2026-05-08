
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/OrderCard.dart';
import '../../Widgets/Tabs.dart';
import '../../app_theme/theme_extension.dart';
import 'MyOrders_Controller.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final controller = Get.put(MyOrdersController());
    final size = MediaQuery.of(context).size;

    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(() => Tabs(
              tabs: controller.tabs,
              selectedIndex: controller.selectedTab.value,
              onTap: controller.changeTab,
            )),
             SizedBox(height: size.height * 0.01),
            Expanded(
              child: ListView(
                children: [
                  OrderCard(
                    orderId: "1042",
                    pharmacyName: "Apex Pharmacy",
                    date: "6 Apr 2026",
                    itemsCount: "5 items",
                    price: "\$125.00",
                    status: "PENDING",
                    statusColor: Colors.orange,
                  ),
                  OrderCard(
                    orderId: "1039",
                    pharmacyName: "City Wellness Center",
                    date: "5 Apr 2026",
                    itemsCount: "12 items",
                    price: "\$430.50",
                    status: "CONFIRMED",
                    statusColor: Colors.blue,
                  ),
                  OrderCard(
                    orderId: "1035",
                    pharmacyName: "Green Cross Pharma",
                    date: "3 Apr 2026",
                    itemsCount: "3 items",
                    price: "\$89.20",
                    status: "DELIVERED",
                    statusColor: Colors.green,
                  ),
                  OrderCard(
                    orderId: "1032",
                    pharmacyName: "North Star Clinic",
                    date: "2 Apr 2026",
                    itemsCount: "8 items",
                    price: "\$215.00",
                    status: "CANCELLED",
                    statusColor: Colors.red,
                  ),
                  OrderCard(
                    orderId: "1035",
                    pharmacyName: "Green Cross Pharma",
                    date: "3 Apr 2026",
                    itemsCount: "3 items",
                    price: "\$89.20",
                    status: "DELIVERED",
                    statusColor: Colors.green,
                  ),
                ],
              ),
            ),


          ],
        ),

    );
  }
}