import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/StatCard.dart';
import '../../app_theme/theme_extension.dart';
import '../EditOrder/EditOrderBinding.dart';
import '../EditOrder/EditOrderScreen.dart';
import 'HeaderCard.dart';
import 'OrderItemCard.dart';
import 'ShowOrder_Controller.dart';

class ShowOrderScreen extends StatelessWidget {
  final int orderId;

  const ShowOrderScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final controller = Get.find<OrderDetailsController>(
      tag: orderId.toString(),
    );
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        backgroundColor: colors.backgroundMain,
        foregroundColor: colors.textPrimary,
        centerTitle: true,
        title: Text(
          "ShowOrder".tr,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        final order = controller.order.value;
        if (order == null) {
          return Center(
            child: Text(
              "No_data".tr,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontFamily: 'Cairo',
              ),
            ),
          );
        }

        return ListView(
          children: [
            SizedBox(height: size.height * 0.01),
            OrderHeaderCard(order: order),
            SizedBox(height: size.height * 0.01),
            Row(
              children: [
                StatCard(
                  icon: Icons.monetization_on,
                  value: order.totalPrice.toString(),
                  title: "Total".tr,
                ),
                StatCard(
                  icon: Icons.percent,
                  value: order.percentage.toString(),
                  title: "Percentage".tr,
                ),
                StatCard(
                  icon: Icons.price_check,
                  value: order.finalPrice.toString(),
                  title: "FinalPrice".tr,
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Padding(
              padding: EdgeInsets.all(size.height * 0.01),
              child: Text(
                "OrderItems".tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            ...order.items.map(
              (item) => Padding(
                padding: EdgeInsets.all(size.height * 0.01),
                child: OrderItemCard(item: item, colors: colors),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(size.height * 0.01),
              child: Text(
                "Notes".tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(size.height * 0.015),
                decoration: BoxDecoration(
                  color: colors.component,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  (order.notes.toString().trim().isEmpty)
                      ? "No_notes_available".tr
                      : order.notes.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: order.notes.toString().trim().isEmpty
                        ? colors.textSecondary
                        : colors.textPrimary,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        );
      }),
      floatingActionButton: Obx(() {
        final order = controller.order.value;

        // التأكد من وجود الطلب وأن حالته pending أو processing فقط
        if (order == null) return const SizedBox.shrink();

        final status = order.status.toLowerCase();
        final canEdit = status == 'pending' || status == 'processing';

        if (!canEdit) return const SizedBox.shrink();

        return FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          child: const Icon(Icons.edit, color: Colors.white),
          onPressed: () {
            Get.to(
              () => EditOrderScreen(orderId: order.id),
              binding: EditOrderBinding(orderId: order.id, order: order),
            );
          },
        );
      }),
    );
  }
}
