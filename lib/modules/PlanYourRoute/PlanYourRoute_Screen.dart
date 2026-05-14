import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/DateCard.dart';
import '../../Widgets/EmptyCard.dart';
import '../../Widgets/RegionSelector/RegionSelector_Screen.dart';
import '../../Widgets/SelectablePharmacyCard.dart';
import '../../app_theme/theme_extension.dart';
import '../TrackRoute/TrackRoute_Screen.dart';
import '../../Widgets/ActiveRegionComponent.dart';
import 'PlanYourRoute_Controller.dart';

class PlanYourRouteScreen extends StatelessWidget {
  const PlanYourRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final controller = Get.put(PlanYourRouteController());

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
              ActiveRegionComponent(),
              SizedBox(height: size.height * 0.024),
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
                        "${controller.selectedPharmacies.length} selected",
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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: controller.setSearch,
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
                    final isAll = controller.isAllSelected;
                    return GestureDetector(
                      onTap: controller.toggleSelectAll,
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

              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.pharmacies.isEmpty) {
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
                            controller.selectedRegion.value = result;
                            controller.fetchPharmacies(result.id);
                          }
                        },
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.filteredPharmacies.length,
                    itemBuilder: (context, index) {
                      final pharmacy = controller.filteredPharmacies[index];

                      return Obx(() {
                        final isSelected = controller.selectedPharmacies
                            .contains(pharmacy.id);

                        return GestureDetector(
                          onTap: () {
                            controller.togglePharmacy(pharmacy.id);
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
                  );
                }),
              ),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 18),
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(TrackRouteScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00796B),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                      SizedBox(width: size.width * 0.05),
                      Text(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
