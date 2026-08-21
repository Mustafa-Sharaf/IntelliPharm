import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/PharmacyOrderCard.dart';
import '../../Widgets/StatCard.dart';
import '../../app_theme/theme_extension.dart';
import '../ActiveDeliveryRoute/ActiveDeliveryRoute_Controller.dart';
import 'HomeContentDistributor_Controller.dart';
import 'HomeContentDistributor_Model.dart';

class HomeContentDistributorScreen extends StatelessWidget {
  const HomeContentDistributorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final controller = Get.find<DeliveryHomeController>();
    final deliveryController = Get.find<ActiveDeliveryRouteController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return SizedBox(
          height: size.height * 0.6,
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
        );
      }

      final homeData = controller.homeData.value;

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 1. Warning Alert
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.018,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffFFF9E6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xffFFEAA7).withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xffD97706),
                      size: 26,
                    ),
                    SizedBox(width: size.width * 0.03),
                    Expanded(
                      child: Text(
                        "${"Order".tr} #1055 ${"due in 45 minutes".tr}",
                        style: const TextStyle(
                          color: Color(0xff78350F),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),

              /// 2. Start Delivery Route Button
              InkWell(
                onTap: () async {
                  bool success = await deliveryController
                      .initiateDeliveryPlan();
                  await deliveryController.fetchTodayDeliveryPlan();
                  if (success) {
                    Get.toNamed('/activeDeliveryRoute');
                  }
                },
                splashColor: Colors.white24,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: size.height * 0.02,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: deliveryController.isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.local_shipping_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                      ),
                      SizedBox(width: size.width * 0.04),
                      Expanded(
                        child: Text(
                          deliveryController.isLoading.value
                              ? "The_map_is_being_created...".tr
                              : "StartDeliveryRoute".tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                      if (!deliveryController.isLoading.value)
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),

              /// 3. Stats Section
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.inventory_2_outlined,
                      value: "${homeData?.totalAssigned ?? 0}",
                      title: "ASSIGNED".tr,
                    ),
                  ),
                  SizedBox(width: size.width * 0.02),
                  Expanded(
                    child: StatCard(
                      icon: Icons.check_circle_outline_rounded,
                      value: "${homeData?.totalCompleted ?? 0}",
                      title: "COMPLETED".tr,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),

              /// 4. Today's Deliveries Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today'sDeliveries".tr,
                    style: TextStyle(
                      fontSize: size.width * 0.048,
                      fontWeight: FontWeight.bold,
                      color: colors.textDefault,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  TextButton(
                    onPressed: ()async {
                      await deliveryController.fetchTodayDeliveryPlan();
                      Get.toNamed('/activeDeliveryRoute');
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      "ViewMap".tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff016E65),
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),

              /// 5. Deliveries List
              if (homeData == null || homeData.todayDeliveries.isEmpty)
                SizedBox(
                  height: size.height * 0.2,
                  child: Center(
                    child: Text(
                      "NoDeliveriesToday".tr,
                      style: const TextStyle(fontFamily: 'Cairo'),
                    ),
                  ),
                )
              else
                Column(
                  children: homeData.todayDeliveries.map((delivery) {
                    return PharmacyOrderCard(
                      orderNumber: delivery.orderId.toString(),
                      pharmacyName: delivery.pharmacyName,
                      itemsCount: delivery.itemsCount,
                      priority: delivery.urgency.toOrderPriority(),
                      status: OrderStatus.pending,
                      onTap: () {},
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      );
    });
  }
}
