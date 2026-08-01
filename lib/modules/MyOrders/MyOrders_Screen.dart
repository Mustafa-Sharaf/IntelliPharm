import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/OrderCard.dart';
import '../../Widgets/Tabs.dart';
import 'MyOrders_Controller.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case "PENDING":
        return Colors.orange;
      case "PROCESSING":
        return Colors.blue;
      case "ON THE WAY":
      case "ON_THE_WAY":
        return Colors.cyanAccent;
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
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: controller.filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = controller.filteredOrders[index];

                  return /*OrderCard(
                    orderId: order.id.toString(),
                    pharmacyName: order.pharmacyName,
                    date: order.date.split(" ").first,
                    itemsCount: "ITEMS_COUNT".trParams({
                      'count': order.itemsCount.toString(),
                    }),
                    price: order.price,
                    status: order.status.tr,
                    statusColor: _getStatusColor(order.status),
                  );*/
                   OrderCard(
                    orderId: order.id.toString(),
                    pharmacyName: order.pharmacyName,
                    date: order.date.split(" ").first,
                    itemsCount: "ITEMS_COUNT".trParams({
                      'count': order.itemsCount.toString(),
                    }),
                    price: order.price,
                    status: order.status.tr,
                    statusColor: _getStatusColor(order.status),
                    onCancel: () {
                      Get.defaultDialog(
                        title: "Cancel_Order".tr,
                        middleText: "Are_you_sure_cancel_order".tr,
                        textConfirm: "Yes".tr,
                        textCancel: "No".tr,
                        confirmTextColor: Colors.white,
                        buttonColor: Colors.red,
                        onConfirm: () {
                          Get.back();
                          controller.cancelOrder(order.id);
                        },
                      );
                    },
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
