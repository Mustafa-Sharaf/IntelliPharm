/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/DeliveryCard.dart';
import '../../app_theme/theme_extension.dart';
import 'MyDeliveries_Controller.dart';

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
                          "Pending",
                          DeliveryTab.pending,
                          controller,
                          colors,
                        ),
                        _buildTabItem(
                          "In Transit",
                          DeliveryTab.inTransit,
                          controller,
                          colors,
                        ),
                        _buildTabItem(
                          "Delivered",
                          DeliveryTab.delivered,
                          controller,
                          colors,
                        ),
                        _buildTabItem(
                          "All",
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

              /// DELIVERIES LIST USING OBX FOR LIVE FILTERING
              Expanded(
                child: Obx(() {
                  final orders = controller.filteredOrders;
                  if (orders.isEmpty) {
                    return const Center(
                      child: Text(
                        "No orders found for this tab",
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
                        address: order.address,
                        itemsCount: order.itemsCount,
                        price: order.price,
                        estTime: order.estTime,
                        assignedTime: order.assignedTime,
                        priority: order.priority,
                        status: order.status,
                        isHospital: order.isHospital,
                        onStartDelivery: () =>
                            controller.startDelivery(order.orderId),
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
              child: Text(
                "3 PENDING · 2 IN TRANSIT · 5 DELIVERED TODAY",
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
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                        _buildTabItem("Pending", DeliveryTab.pending, controller, colors),
                        _buildTabItem("In Transit", DeliveryTab.inTransit, controller, colors),
                        _buildTabItem("Delivered", DeliveryTab.delivered, controller, colors),
                        _buildTabItem("All", DeliveryTab.all, controller, colors),
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
                    return const Center(child: CircularProgressIndicator());
                  }

                  final orders = controller.ordersList;
                  if (orders.isEmpty) {
                    return const Center(
                      child: Text(
                        "No orders found for this tab",
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
                        address: order.pharmacistName, // أو نمرر العنوان الافتراضي حسب التصميم
                        itemsCount: order.itemsCount,
                        price: order.price,
                        estTime: order.scheduledTime.split(' ').last, // جلب الوقت من التاريخ
                        assignedTime: order.createdAt.substring(11, 16), // اقتطاع وقت الإنشاء
                        priority: order.priority,
                        status: order.status,
                        isHospital: false, // قيمة ثابتة أو تضبط حسب الكلمة بالاسم (مثلاً يحتوي Hospital)
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
                  "${controller.pendingCount} PENDING · ${controller.inTransitCount} IN TRANSIT · ${controller.deliveredCount} DELIVERED TODAY",
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