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
