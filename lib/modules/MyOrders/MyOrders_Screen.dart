import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/OrderCard.dart';
import '../../Widgets/Tabs.dart';
import '../../app_theme/theme_extension.dart';
import 'MyOrders_Controller.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  Color _getStatusColor(String status) {
    switch (status) {
      case "PENDING":
        return Colors.orange;
      case "PROCESSING":
        return Colors.blue;
      case "COMPLETED":
        return Colors.green;
      case "CANCELLED":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final controller = Get.find<MyOrdersController>();
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Obx(
            () => Tabs(
              tabs: controller.tabs,
              selectedIndex: controller.selectedTab.value,
              onTap: controller.changeTab,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = controller.filteredOrders[index];

                  return OrderCard(
                    orderId: order.id.toString(),
                    pharmacyName: order.pharmacyName,
                    date: order.date.split(" ").first,
                    itemsCount: "ITEMS_COUNT".trParams({
                      'count': order.itemsCount.toString(),
                    }),
                    price: order.price,
                    status: order.status.tr,
                    statusColor: _getStatusColor(order.status),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
