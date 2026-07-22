import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/DateCard.dart';
import '../../Widgets/ActiveRegionComponent.dart';
import '../../app_theme/theme_extension.dart';
import 'Components/GenerateRouteButton.dart';
import 'Components/PharmaciesSliverList.dart';
import 'PlanYourRoute_Controller.dart';
import 'Components/ProfileSelector.dart';
import 'Components/TravelModeSelector.dart';

class PlanYourRouteScreen extends StatelessWidget {
  const PlanYourRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final planYourRouteController = Get.find<PlanYourRouteController>();

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        backgroundColor: colors.backgroundMain,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          "PlanYourRoute".tr,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Cairo',
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.withValues(alpha: 0.3),
            height: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  controller: planYourRouteController.scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: size.height * 0.02),
                          DateCard(),
                          SizedBox(height: size.height * 0.022),
                          /// TRAVEL MODE SELECTOR WIDGET
                          TravelModeSelector(),
                          SizedBox(height: size.height * 0.022),
                          /// PROFILE SELECTOR WIDGET
                          const ProfileSelector(),
                          SizedBox(height: size.height * 0.015),
                          /// REGION SELECTOR
                          Obx(
                            () => ActiveRegionComponent(
                              text: "REGION".tr,
                              selectedRegionName: planYourRouteController
                                  .selectedRegion
                                  .value
                                  ?.name,
                              onRegionSelected: (region) {
                                planYourRouteController.updateRegion(region);
                              },
                            ),
                          ),
                          SizedBox(height: size.height * 0.024),
                          /// HEADER
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Select_Pharmacies_to_Visit".tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xff52E0D3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Obx(
                                  () => Text(
                                    "pharmacies_selected".trParams({
                                      'count': planYourRouteController
                                          .selectedPharmacies
                                          .length
                                          .toString(),
                                    }),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Cairo',
                                      color: AppColors.textLightPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.014),

                          /// SEARCH + SELECT ALL
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  onChanged: planYourRouteController.setSearch,
                                  decoration: InputDecoration(
                                    hintText: "Search_pharmacy_name_...".tr,
                                    hintStyle: TextStyle(
                                      fontSize: 13.5,
                                      fontFamily: 'Cairo',
                                      color: colors.textSecondary.withValues(alpha: 0.7),
                                      fontWeight: FontWeight.normal,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: colors.component,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: size.width * 0.02),
                              Obx(() {
                                final isAll = planYourRouteController.isAllSelected;
                                return GestureDetector(
                                  onTap: planYourRouteController.toggleSelectAll,
                                  child: Container(
                                    width: size.width * 0.06,
                                    height: size.width * 0.06,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isAll
                                          ? colors.textPrimary
                                          : colors.component,
                                      border: Border.all(
                                        color: colors.textPrimary,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      isAll ? Icons.check : Icons.done_all,
                                      color: isAll
                                          ? Colors.white
                                          : colors.textPrimary,
                                      size: 15,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                          SizedBox(height: size.height * 0.02),
                        ],
                      ),
                    ),

                    /// PHARMACIES SLIVER LIST COMPONENT
                    const PharmaciesSliverList(),
                  ],
                ),
              ),

              /// BUTTON FIXED AT BOTTOM
              const GenerateRouteButton(),
            ],
          ),
        ),
      ),
    );
  }
}
