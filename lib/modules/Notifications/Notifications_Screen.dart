import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import 'NotificationCard.dart';
import 'notifications_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});





  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final controller = Get.find<NotificationsController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.backgroundMain,
        foregroundColor: colors.textPrimary,
        centerTitle: true,
        title: Text(
          "Notifications".tr,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Cairo',
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,

          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return  Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
        }

        if (controller.groupedNotifications.isEmpty) {
          return Center(
            child: Text(
              "NoNotifications".tr,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600,fontFamily: 'Cairo'),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchNotifications(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.groupedNotifications.length,
            itemBuilder: (_, index) {
              final group = controller.groupedNotifications[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      group.dateHeader,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                          fontFamily: 'Cairo'
                      ),
                    ),
                  ),
                  ...group.items.map(
                        (notification) => NotificationCard(notification: notification),
                  ),
                ],
              );
            },
          ),
        );
      }),
    );
  }
}