/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/DateCard.dart';
import '../../Widgets/EmptyCard.dart';
import '../../Widgets/RegionSelector/RegionSelector_Screen.dart';
import '../../Widgets/SelectablePharmacyCard.dart';
import '../../Widgets/ActiveRegionComponent.dart';
import '../../app_theme/theme_extension.dart';
import 'PlanYourRoute_Controller.dart';

class PlanYourRouteScreen extends StatelessWidget {
  PlanYourRouteScreen({super.key});

  final List<String> types = ["Walking", "Driving"];

  final Map<String, IconData> typeIcons = {
    "Walking": Icons.directions_walk,
    "Driving": Icons.directions_car,
  };

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
          "Plan Your Route",
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Cairo',
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),

          child: Container(color: Colors.grey, height: 1),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.02),
              DateCard(),
              SizedBox(height: size.height * 0.022),
              Row(
                children: [
                  Text(
                    "TRAVEL MODE",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      color: colors.textSecondary,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              Obx(
                () => Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: colors.component,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: types.map((type) {
                      final isSelected =
                          planYourRouteController.selectedType.value == type;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              planYourRouteController.selectedType.value = type,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    typeIcons[type],
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.gray,
                                    size: 20,
                                  ),
                                  SizedBox(width: size.width * 0.008),
                                  Text(
                                    type,
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 16,
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.gray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.022),

              /// REGION SELECTOR
              Obx(
                () => ActiveRegionComponent(
                  text: "REGION",
                  selectedRegionName:
                      planYourRouteController.selectedRegion.value?.name,
                  onRegionSelected: (region) {
                    planYourRouteController.selectedRegion.value = region;
                    planYourRouteController.fetchPharmacies(region.id);
                  },
                ),
              ),

              SizedBox(height: size.height * 0.024),

              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Pharmacies to Visit",
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
                        "${planYourRouteController.selectedPharmacies.length} selected",
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
                        hintText: "Search pharmacy name ...",
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: colors.component,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
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

                          color: isAll ? colors.textPrimary : colors.component,

                          border: Border.all(
                            color: colors.textPrimary,
                            width: 2,
                          ),
                        ),

                        child: Icon(
                          isAll ? Icons.check : Icons.done_all,

                          color: isAll ? Colors.white : colors.textPrimary,

                          size: 15,
                        ),
                      ),
                    );
                  }),
                ],
              ),

              SizedBox(height: size.height * 0.02),

              /// LIST
              Expanded(
                child: Obx(() {
                  /// FIRST LOADING
                  if (planYourRouteController.isLoading.value &&
                      planYourRouteController.pharmacies.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  /// EMPTY
                  if (planYourRouteController.pharmacies.isEmpty) {
                    return Center(
                      child: EmptyPlanCard(
                        title: "Nothing pharmacies yet.",
                        subtitle:
                            "The pharmacies will appear here once you have selected the area you will be visiting.",
                        buttonText: "Select Region",
                        onPressed: () async {
                          final result = await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),

                            builder: (context) {
                              return RegionSelector();
                            },
                          );

                          if (result != null) {
                            planYourRouteController.selectedRegion.value =
                                result;

                            planYourRouteController.fetchPharmacies(result.id);
                          }
                        },
                      ),
                    );
                  }

                  /// LIST VIEW
                  return RefreshIndicator(
                    onRefresh: planYourRouteController.refreshPharmacies,
                    color: AppColors.primaryColor,
                    backgroundColor: colors.component,

                    child: ListView.builder(
                      controller: planYourRouteController.scrollController,

                      itemCount:
                          planYourRouteController.filteredPharmacies.length +
                          (planYourRouteController.hasMore.value ? 1 : 0),

                      itemBuilder: (context, index) {
                        /// LOADING ITEM
                        if (index ==
                            planYourRouteController.filteredPharmacies.length) {
                          return const Padding(
                            padding: EdgeInsets.all(20),

                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          );
                        }

                        final pharmacy =
                            planYourRouteController.filteredPharmacies[index];

                        return Obx(() {
                          final isSelected = planYourRouteController
                              .selectedPharmacies
                              .contains(pharmacy.id);

                          return GestureDetector(
                            onTap: () {
                              planYourRouteController.togglePharmacy(
                                pharmacy.id,
                              );
                            },

                            child: SelectablePharmacyCard(
                              id: pharmacy.id,

                              title: pharmacy.name,

                              subtitle: pharmacy.region,

                              checked: isSelected,
                            ),
                          );
                        });
                      },
                    ),
                  );
                }),
              ),

              /// BUTTON
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 18),
                child: Obx(() {
                  final bool isLoading = planYourRouteController.isLoading.value;

                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => planYourRouteController.initiatePlan(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,

                      disabledBackgroundColor: AppColors.primaryColor.withValues(alpha: 0.6),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: size.width * 0.05),
                        const Text(
                          "Generate Optimal Route",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/DateCard.dart';
import '../../Widgets/EmptyCard.dart';
import '../../Widgets/RegionSelector/RegionSelector_Screen.dart';
import '../../Widgets/SelectablePharmacyCard.dart';
import '../../Widgets/ActiveRegionComponent.dart';
import '../../app_theme/theme_extension.dart';
import 'PlanYourRoute_Controller.dart';

class PlanYourRouteScreen extends StatelessWidget {
  PlanYourRouteScreen({super.key});

  final List<String> types = ["Walking", "Driving"];

  final Map<String, IconData> typeIcons = {
    "Walking": Icons.directions_walk,
    "Driving": Icons.directions_car,
  };

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
          "Plan Your Route",
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Cairo',
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.withValues(alpha: 0.3), height: 1),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: size.height * 0.02),
                          DateCard(),
                          SizedBox(height: size.height * 0.022),
                          Text(
                            "TRAVEL MODE",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              color: colors.textSecondary,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Obx(
                                () => Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: colors.component,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: types.map((type) {
                                  final isSelected = planYourRouteController.selectedType.value == type;
                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () => planYourRouteController.selectedType.value = type,
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          color: isSelected ? AppColors.primaryColor : Colors.transparent,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                typeIcons[type],
                                                color: isSelected ? Colors.white : AppColors.gray,
                                                size: 20,
                                              ),
                                              SizedBox(width: size.width * 0.008),
                                              Text(
                                                type,
                                                style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  fontSize: 16,
                                                  color: isSelected ? Colors.white : AppColors.gray,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.022),

                          /// REGION SELECTOR
                          Obx(
                                () => ActiveRegionComponent(
                              text: "REGION",
                              selectedRegionName: planYourRouteController.selectedRegion.value?.name,
                              onRegionSelected: (region) {
                                // تعديل التابع ليعمل بالتوافق مع التصفير الجديد
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
                                "Select Pharmacies to Visit",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xff52E0D3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Obx(
                                      () => Text(
                                    "${planYourRouteController.selectedPharmacies.length} selected",
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
                                    hintText: "Search pharmacy name ...",
                                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
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
                                      color: isAll ? colors.textPrimary : colors.component,
                                      border: Border.all(color: colors.textPrimary, width: 2),
                                    ),
                                    child: Icon(
                                      isAll ? Icons.check : Icons.done_all,
                                      color: isAll ? Colors.white : colors.textPrimary,
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

                    /// LIST OR EMPTY STATE
                    Obx(() {
                      // 1. حالة التحميل الأولية
                      if (planYourRouteController.isLoading.value && planYourRouteController.pharmacies.isEmpty) {
                        return const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      // 2. حالة القائمة الفارغة
                      if (planYourRouteController.pharmacies.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: EmptyPlanCard(
                              title: "Nothing pharmacies yet.",
                              subtitle: "The pharmacies will appear here once you have selected the area you will be visiting.",
                              buttonText: "Select Region",
                              onPressed: () async {
                                final result = await showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  ),
                                  builder: (context) => RegionSelector(),
                                );

                                if (result != null) {
                                  planYourRouteController.updateRegion(result);
                                }
                              },
                            ),
                          ),
                        );
                      }

                      // 3. عرض القائمة عند وجود بيانات باستخدام SliverList
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            if (index == planYourRouteController.filteredPharmacies.length) {
                              return const Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: CircularProgressIndicator(color: AppColors.primaryColor),
                                ),
                              );
                            }

                            final pharmacy = planYourRouteController.filteredPharmacies[index];

                            return Obx(() {
                              final isSelected = planYourRouteController.selectedPharmacies.contains(pharmacy.id);

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: GestureDetector(
                                  onTap: () => planYourRouteController.togglePharmacy(pharmacy.id),
                                  child: SelectablePharmacyCard(
                                    id: pharmacy.id,
                                    title: pharmacy.name,
                                    subtitle: pharmacy.region,
                                    checked: isSelected,
                                  ),
                                ),
                              );
                            });
                          },
                          childCount: planYourRouteController.filteredPharmacies.length + (planYourRouteController.hasMore.value ? 1 : 0),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              /// BUTTON FIXED AT BOTTOM
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Obx(() {
                  final bool isLoading = planYourRouteController.isLoading.value;

                  return ElevatedButton(
                    onPressed: isLoading ? null : () => planYourRouteController.initiatePlan(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      disabledBackgroundColor: AppColors.primaryColor.withValues(alpha: 0.6),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                        SizedBox(width: size.width * 0.05),
                        const Text(
                          "Generate Optimal Route",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}