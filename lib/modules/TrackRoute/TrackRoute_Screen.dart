import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Widgets/BuildSelector.dart';
import '../../Widgets/CustomTextField.dart';
import '../../Widgets/RegionSelector/RegionSelector_Screen.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import 'TrackRoute_Controller.dart';

class TrackRouteScreen extends StatelessWidget {
  TrackRouteScreen({super.key});

  final controller = Get.put(TrackRouteController());

  final List<String> types = ["خطة جديدة", "تحديث خطة"];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => GoogleMap(
              onMapCreated: (mapCtrl) async {
                controller.mapController.value = mapCtrl;

                await Future.delayed(Duration(milliseconds: 100));

                controller.applyMapStyle();
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  controller.latitude.value,
                  controller.longitude.value,
                ),
                zoom: 14,
              ),
              markers: {controller.pharmacyMarker.value},
              onTap: (point) {
                controller.setLocation(point.latitude, point.longitude);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
          ),
          Positioned(
            right: MediaQuery.of(context).size.height * 0.01,
            bottom: MediaQuery.of(context).size.height * 0.33,
            child: FloatingActionButton(
              onPressed: controller.moveToCurrentLocation,
              backgroundColor: colors.component,
              child: Icon(Icons.my_location, color: AppColors.primaryColor),
            ),
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
                      onTap: () {
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
                      },
                      iconColor: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Obx(
                    () => BuildSelector(
                      title: "Plan_type".tr,
                      value: controller.selectedType.value,
                      icon: Icons.sync_alt,
                      iconColor: AppColors.primaryColor,
                      onTap: () => _showBottomList(
                        context,
                        "اختر النوع",
                        types,
                        (val) => controller.selectedType.value = val,
                      ),
                    ),
                  ),
                  CustomTextField(
                    label: "Reason_details".tr,
                    icon: Icons.edit_note,
                    //controller: controller.pharmacyNameController,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
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

  /// ================= BOTTOM LIST =================
  void _showBottomList(
    BuildContext context,
    String title,
    List<String> items,
    Function(String) onSelect,
  ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...items.map(
              (e) => ListTile(
                title: Text(e),
                onTap: () {
                  onSelect(e);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
