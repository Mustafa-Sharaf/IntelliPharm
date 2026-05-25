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
                      Obx(() => ActiveRegionComponent(
                        text: "REGION",
                        selectedRegionName: addPharmacyController.selectedRegion.value?.name,
                        onRegionSelected: (region) {
                          addPharmacyController.selectedRegion.value = region;
                        },
                      )),

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
                  child: Obx(() => ElevatedButton.icon(
                    onPressed: addPharmacyController.isLoading.value
                        ? null
                        : () => addPharmacyController.savePharmacy(),
                    icon: addPharmacyController.isLoading.value
                        ? const SizedBox.shrink()
                        : const Icon(Icons.save_outlined, color: Colors.white),
                    label: addPharmacyController.isLoading.value
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
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
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/BuildGestureDetector.dart';
import '../../Widgets/BuildSelector.dart';
import '../../Widgets/CustomAppBar.dart';
import '../../Widgets/RegionSelector/RegionSelector_Model.dart';
import '../../Widgets/RegionSelector/RegionSelector_Screen.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../../helper/mapHelper/dart/MapHelper_Screen.dart';
import 'AddPharmacy_Controller.dart';
import '../../Widgets/CustomTextField.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';

class AddPharmacyScreen extends StatelessWidget {
  const AddPharmacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    Get.put(MapHelperController(), tag: "addPharmacy");
    final controller = Get.put(AddPharmacyController());
    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: CustomAppBar(title: "Add_pharmacy".tr),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                label: "PharmacyName".tr,
                icon: Icons.local_pharmacy,
                controller: controller.pharmacyNameController,
              ),
              CustomTextField(
                label: "Pharmacist'sName".tr,
                icon: Icons.person,
                controller: controller.pharmacistsNameController,
              ),
              Obx(
                () => BuildSelector(
                  title: "Region".tr,
                  value: controller.selectedRegion.value?.name ?? "",
                  icon: Icons.map,
                  onTap: () async {
                    final result = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (_) => RegionSelector(),
                    );
                    if (result != null && result is RegionModel) {
                      controller.selectedRegion.value = result;
                    }
                  },
                  iconColor: AppColors.primaryColor,
                ),
              ),
              Obx(
                () => Column(
                  children: List.generate(
                    controller.phoneControllers.length,
                    (index) => Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: "PhoneNumber".tr,
                            icon: Icons.phone_android,
                            controller: controller.phoneControllers[index],
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        index == 0 && controller.phoneControllers.length < 2
                            ? IconButton(
                                onPressed: controller.addPhoneField,
                                icon: Icon(
                                  Icons.add_circle,
                                  color: AppColors.primaryColor,
                                  size: 28,
                                ),
                              )
                            : index != 0
                            ? IconButton(
                                onPressed: () =>
                                    controller.removePhoneField(index),
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                  size: 28,
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(
                () => Row(
                  children: [
                    BuildGestureDetector(
                      onTap: () => controller.pickTime(
                        context: context,
                        targetTime: controller.openTime,
                        backgroundColor: colors.component,
                      ),
                      text: controller.openTime.value == null
                          ? "Opening_Time".tr
                          : controller.openTime.value!.format(context),
                      icon: Icons.access_time,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    BuildGestureDetector(
                      onTap: () => controller.pickTime(
                        context: context,
                        targetTime: controller.closeTime,
                        backgroundColor: colors.component,
                      ),
                      text: controller.closeTime.value == null
                          ? "Closing_Time".tr
                          : controller.closeTime.value!.format(context),
                      icon: Icons.access_time_filled,
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.007),
              MapHelperScreen(
                tag: "addPharmacy",
                height: MediaQuery.of(context).size.height * 0.45,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.007),
              ElevatedButton.icon(
                onPressed: controller.createPharmacy,
                icon: const Icon(
                  Icons.add_business_rounded,
                  color: AppColors.primaryColor,
                ),
                label: Text(
                  "Add_pharmacy".tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                    fontFamily: 'Cairo',
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
*/
/*
import 'package:flutter/material.dart';

import '../../app_theme/theme_extension.dart';

class AddPharmacyScreen extends StatelessWidget {
  const AddPharmacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colors.backgroundMain,
     */
