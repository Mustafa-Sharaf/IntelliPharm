import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/ActiveRegionComponent.dart';
import '../../Widgets/BuildGestureDetector.dart';
import '../../app_theme/theme_extension.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../../helper/mapHelper/dart/MapHelper_Screen.dart';
import 'AddPharmacy_Controller.dart';
import 'LocationCoordinatesSection.dart';
import 'PharmacyContactSection.dart';
import 'PharmacyNameSection.dart';

class AddPharmacyScreen extends StatelessWidget {
  const AddPharmacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MapHelperController(), tag: "addPharmacy");
    final addPharmacyController = Get.put(AddPharmacyController());
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    TextStyle sectionTitleStyle = TextStyle(
      fontSize: 12,
      fontFamily: 'Cairo',
      fontWeight: FontWeight.bold,
      color: colors.textSecondary,
      letterSpacing: 1,
    );

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      body: SafeArea(
        child: Form(
          key: addPharmacyController.formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: size.width * 0.03,
                    right: size.width * 0.03,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => ActiveRegionComponent(
                          text: "REGION",
                          selectedRegionName:
                              addPharmacyController.selectedRegion.value?.name,
                          onRegionSelected: (region) {
                            addPharmacyController.selectedRegion.value = region;
                          },
                        ),
                      ),

                      // --- SECTION: PHARMACY NAME ---
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.width * 0.03,
                          bottom: size.width * 0.02,
                        ),
                        child: Text('PHARMACY NAME', style: sectionTitleStyle),
                      ),
                      PharmacyNameSection(
                        addPharmacyController: addPharmacyController,
                      ),

                      SizedBox(height: size.height * 0.02),

                      // --- SECTION: LOCATION ---
                      Container(
                        decoration: BoxDecoration(
                          color: colors.component,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: size.height * 0.008),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: size.height * 0.008),
                                Text('LOCATION', style: sectionTitleStyle),
                              ],
                            ),
                            SizedBox(height: size.height * 0.008),
                            MapHelperScreen(
                              tag: "addPharmacy",
                              height: MediaQuery.of(context).size.height * 0.45,
                              right: size.height * -0.005,
                              bottom: size.height * 0.4,
                            ),

                            LocationCoordinateSection(),
                          ],
                        ),
                      ),

                      // --- SECTION: WORKING HOURS ---
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.02,
                          bottom: size.height * 0.01,
                        ),
                        child: Text('WORKING HOURS', style: sectionTitleStyle),
                      ),
                      Obx(
                        () => Row(
                          children: [
                            BuildGestureDetector(
                              onTap: () => addPharmacyController.pickTime(
                                context: context,
                                targetTime: addPharmacyController.openTime,
                                backgroundColor: colors.component,
                              ),
                              text: addPharmacyController.openTime.value == null
                                  ? "Opening_Time".tr
                                  : addPharmacyController.openTime.value!
                                        .format(context),
                              icon: Icons.access_time,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            BuildGestureDetector(
                              onTap: () => addPharmacyController.pickTime(
                                context: context,
                                targetTime: addPharmacyController.closeTime,
                                backgroundColor: colors.component,
                              ),
                              text:
                                  addPharmacyController.closeTime.value == null
                                  ? "Closing_Time".tr
                                  : addPharmacyController.closeTime.value!
                                        .format(context),
                              icon: Icons.access_time_filled,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: size.height * 0.02),

                      // --- SECTION: ACTIVE STATUS ---
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.02,
                          vertical: size.width * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: colors.component,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pharmacy is Active',
                              style: TextStyle(
                                fontSize: 14,
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            Obx(
                              () => Switch(
                                value: addPharmacyController.isActive.value,
                                activeThumbColor: AppColors.primaryColor,
                                onChanged: (val) =>
                                    addPharmacyController.isActive.value = val,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // --- SECTION: CONTACT INFO ---
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.02,
                          bottom: size.height * 0.01,
                        ),
                        child: Text('CONTACT INFO', style: sectionTitleStyle),
                      ),
                      PharmacyContactSection(
                        addPharmacyController: addPharmacyController,
                      ),

                      SizedBox(height: size.height * 0.01),
                    ],
                  ),
                ),
              ),
              // --- BOTTOM BUTTON: SAVE PHARMACY ---
              Container(
                padding: EdgeInsets.all(size.width * 0.03),
                color: colors.component,
                child: SizedBox(
                  width: double.infinity,
                  height: size.height * 0.06,
                  child: Obx(
                    () => ElevatedButton.icon(
                      onPressed: addPharmacyController.isLoading.value
                          ? null
                          : () => addPharmacyController.createPharmacy(),
                      icon: addPharmacyController.isLoading.value
                          ? const SizedBox.shrink()
                          : const Icon(
                              Icons.save_outlined,
                              color: Colors.white,
                            ),
                      label: addPharmacyController.isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'SAVE PHARMACY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                fontFamily: 'Cairo',
                              ),
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
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
