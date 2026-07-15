import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/DeliveryCard.dart';
import '../../app_theme/theme_extension.dart';
import 'MyDeliveries_Controller.dart';
import 'MyDeliveries_Model.dart';

class MyDeliveriesScreen extends StatelessWidget {
  const MyDeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyDeliveriesController());
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: size.height * 0.02),

              /// CUSTOM TAB BAR
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: colors.component,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Obx(
                    () => Row(
                      children: [
                        _buildTabItem(
                          "Pending".tr,
                          DeliveryTab.pending,
                          controller,
                          colors,
                        ),
                        _buildTabItem(
                          "InTransit".tr,
                          DeliveryTab.inTransit,
                          controller,
                          colors,
                        ),
                        _buildTabItem(
                          "Delivered".tr,
                          DeliveryTab.delivered,
                          controller,
                          colors,
                        ),
                        _buildTabItem(
                          "All".tr,
                          DeliveryTab.all,
                          controller,
                          colors,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.02),

              /// DELIVERIES LIST USING OBX
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
                  }
                  final orders = controller.ordersList;
                  if (orders.isEmpty) {
                    return Center(
                      child: Text(
                        "No_orders_found_for_this_tab".tr,
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 14),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: size.height * 0.1),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      return DeliveryCard(
                        orderId: order.orderId,
                        clientName: order.clientName,
                        address: order.pharmacistName,
                        itemsCount: order.itemsCount,
                        price: order.price,
                        estTime: order.scheduledTime.split(' ').last,
                        assignedTime: order.createdAt.substring(11, 16),
                        priority: order.priority,
                        status: order.status,
                        isHospital: false,
                        onStartDelivery: () => controller.startDelivery(order.orderId),
                      );
                    },
                  );
                }),
              ),
            ],
          ),

          /// FLOATING SUMMARY BOTTOM BAR
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: colors.component,
              padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
              child: Obx(
                () => Text(
                  //"${controller.pendingCount} PENDING · ${controller.inTransitCount} IN TRANSIT · ${controller.deliveredCount} DELIVERED TODAY",
                  "DELIVERY_SUMMARY".trParams({
                    'pending': controller.pendingCount.toString(),
                    'transit': controller.inTransitCount.toString(),
                    'delivered': controller.deliveredCount.toString(),
                  }),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                    fontFamily: 'Cairo',
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(
    String text,
    DeliveryTab tab,
    MyDeliveriesController controller,
    ThemeColors colors,
  ) {
    final isSelected = controller.currentTab.value == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(tab),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? colors.backgroundMain : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? colors.textPrimary : colors.textSecondary,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ),
    );
  }
}
