import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../../helper/ContactLauncher/ContactLauncher.dart';
import '../NewOrder/NewOrder_Screen.dart';
import '../PlanYourRoute/PlanYourRoute_Controller.dart';


class BuildActionButtons extends StatelessWidget {
  final dynamic pharmacy;
  const BuildActionButtons({super.key, required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            //Get.to(() => NewOrderScreen());
            Get.toNamed("/newOrderScreen");
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            height: size.height * 0.06,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_shopping_cart, color: Colors.white, size: 22),
                SizedBox(width: size.width * 0.02),
                Text(
                  "CreateOrder".tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: size.height * 0.02),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  final planYourRouteController = Get.find<PlanYourRouteController>();
                  if (planYourRouteController.selectedType.value.isEmpty) {
                    planYourRouteController.selectedType.value = "Driving";
                  }
                  planYourRouteController.initiatePlan(singlePharmacy: pharmacy);
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFD1D5DB),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        color: Color(0xFF0F2547),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Map".tr,
                        style: TextStyle(
                          color: Color(0xFF0F2547),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: size.width * 0.03),
            Expanded(
              child: InkWell(
                onTap: () {
                  ContactLauncher().showContactOptions(
                    context,
                    pharmacy.pharmacistPhone,
                  );
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFD1D5DB),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone_in_talk_outlined,
                        color: Color(0xFF0F2547),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Call".tr,
                        style: TextStyle(
                          color: Color(0xFF0F2547),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
