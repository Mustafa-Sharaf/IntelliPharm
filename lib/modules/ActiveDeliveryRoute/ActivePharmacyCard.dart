import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../ActiveDeliveryRoute/ActiveDeliveryRoute_Controller.dart';
import '../ActiveDeliveryRoute/ActiveDeliveryRoute_Model.dart';
import '../ActiveOptimizedRouteTracking/PlanRouteCalculator.dart';

class ActivePharmacyCard extends StatelessWidget {
  final DeliveryPlan plan;
  final ActiveDeliveryRouteController controller;

  const ActivePharmacyCard({
    super.key,
    required this.plan,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return Obx(() {
      if (plan.visits.isEmpty ||
          controller.activeVisitIndex.value >= plan.visits.length) {
        return const SizedBox.shrink();
      }
      final activeVisit = plan.visits[controller.activeVisitIndex.value];

      return Column(
        children: [
          SizedBox(height: size.height * 0.02),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.local_pharmacy_outlined,
                  color: AppColors.primaryColor,
                ),
              ),
               SizedBox(width: size.width * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activeVisit.pharmacyName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.textDefault,
                        fontFamily: 'Cairo',
                      ),
                    ),
                     SizedBox(height: size.height * 0.01),
                    Text(
                      "ETA ${PlanRouteCalculator.getETAForVisit(plan.toPlanResponse(), controller.activeVisitIndex.value)} • Order #${activeVisit.id}",
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
           SizedBox(height: size.height * 0.02),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colors.textSecondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.layers_outlined,
                      size: 16,
                      color: colors.textSecondary,
                    ),
                     SizedBox(width: size.width * 0.01),
                    Text(
                      "5 items",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colors.textDefault,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
               SizedBox(width: size.width * 0.03),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {

                  },
                  icon: const Icon(
                    //Icons.navigation_outlined,
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  label: Text(
                    //"NAVIGATE".tr,
                    "RePlan".tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}