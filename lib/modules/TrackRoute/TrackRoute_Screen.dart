import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/BuildSelector.dart';
import '../../Widgets/CustomTextField.dart';
import '../../Widgets/RegionSelector/RegionSelector_Screen.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../../helper/mapHelper/dart/MapHelper_Screen.dart';
import 'TrackRoute_Controller.dart';

class TrackRouteScreen extends StatelessWidget {
  TrackRouteScreen({super.key});

  final List<String> types = ["New_plan".tr, "Plan_update".tr];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TrackRouteController());
    final colors = Theme.of(context).extension<ThemeColors>()!;
    Get.lazyPut(() => MapHelperController(), tag: "route");
    return Scaffold(
      body: Stack(
        children: [
          MapHelperScreen(
            tag:"route" ,
            right: MediaQuery.of(context).size.height * 0.01,
            bottom: MediaQuery.of(context).size.height * 0.33,
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.backgroundMain,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => BuildSelector(
                      title: "Region".tr,
                      value: controller.selectedRegion.value,
                      icon: Icons.map,
                      /*onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) {
                            return RegionSelector();
                          },
                        );
                      },*/
                      onTap: () async {
                        final result = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) {
                            return RegionSelector();
                          },
                        );

                        if (result != null) {
                          controller.selectedRegion.value = result.id.toString();
                        }
                      },
                      iconColor: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
                              controller.selectedType.value == type;

                          return Expanded(
                            child: GestureDetector(
                              onTap: () => controller.selectedType.value = type,
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
                                  child: Text(
                                    type,
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 16,
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.gray,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  CustomTextField(
                    label: "Reason_details".tr,
                    icon: Icons.edit_note,
                    controller: controller.detailsController,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                        onPressed: () async {
                          final controller = Get.find<TrackRouteController>();

                          /// 📍 لازم تجيب الموقع الحالي
                          final mapController = Get.find<MapHelperController>(tag: "route");

                          final currentLocation = await mapController.getCurrentLocation();

                          if (controller.selectedRegion.value.isEmpty) {
                            Get.snackbar("Error", "Please select region");
                            return;
                          }

                          if (controller.selectedType.value.isEmpty) {
                            Get.snackbar("Error", "Please select plan type");
                            return;
                          }

                          await controller.initiatePlan(
                            lat: currentLocation.latitude,
                            lng: currentLocation.longitude,
                            regionId: int.parse(controller.selectedRegion.value),
                          );
                        },
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: Text(
                        "Send".tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
