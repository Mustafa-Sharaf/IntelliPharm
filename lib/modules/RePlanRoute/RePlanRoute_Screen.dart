import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/SelectablePharmacyCard.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../../helper/mapHelper/dart/MapHelper_Screen.dart';
import 'RePlanRoute_Controller.dart';

class RePlanRouteScreen extends StatelessWidget {
  const RePlanRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    // Get.lazyPut(() => MapHelperController(), tag: "route");
    final size = MediaQuery.of(context).size;
    final controller = Get.find<RePlanRouteController>();
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                MapHelperScreen(
                  tag: "route",
                  right: MediaQuery.of(context).size.height * 0.01,
                  bottom: MediaQuery.of(context).size.height * 0.02,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.backgroundMain,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: EdgeInsets.all(size.height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: size.height * 0.05,
                        height: size.height * 0.005,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Re-planRoute".tr,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    Text(
                      "WHY_ARE_YOU_RE-PLANNING_?".tr,
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _reasonChip(
                          title: "Traffic Jam",
                          controller: controller,
                        ),
                        _reasonChip(
                          title: "Road Closure",
                          controller: controller,
                        ),
                        _reasonChip(
                          title: "Accident Ahead",
                          controller: controller,
                        ),
                        _reasonChip(
                          title: "Pharmacy Closed",
                          controller: controller,
                        ),
                        _reasonChip(
                          title: "Schedule Change",
                          controller: controller,
                        ),
                        _reasonChip(title: "Other".tr, controller: controller),
                      ],
                    ),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "REMOVE_UNVISITED_STOPS".tr,
                          style: TextStyle(
                            color: colors.textDefault,
                            fontFamily: 'Cairo',
                            fontSize: 13,
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.25,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "2 STOPS REMAINING",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.01),
                    SizedBox(
                      height: size.height * 0.22,
                      child: ListView(
                        children: [
                          SelectablePharmacyCard(
                            id: 1,
                            title: "pharmacy.name",
                            subtitle: "pharmacy.region",
                            checked: true,
                          ),
                          SelectablePharmacyCard(
                            id: 2,
                            title: "pharmacy.name",
                            subtitle: "pharmacy.region",
                            checked: false,
                          ),
                          SelectablePharmacyCard(
                            id: 2,
                            title: "pharmacy.name",
                            subtitle: "pharmacy.region",
                            checked: false,
                          ),
                          SelectablePharmacyCard(
                            id: 2,
                            title: "pharmacy.name",
                            subtitle: "pharmacy.region",
                            checked: false,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.01),
                    Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2A9D8F), Color(0xFF264653)],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.alt_route, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              "Re-plan_Now".tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reasonChip({
    required String title,
    required RePlanRouteController controller,
  }) {
    bool isSelected = controller.selectedReason == title;

    return GestureDetector(
      onTap: () => controller.selectReason(title),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D3B66) : Colors.white,

          borderRadius: BorderRadius.circular(30),

          border: Border.all(
            color: isSelected ? const Color(0xFF0D3B66) : Colors.grey.shade300,
          ),
        ),

        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF0D3B66),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
