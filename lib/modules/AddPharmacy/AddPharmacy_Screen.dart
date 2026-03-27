import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Widgets/CustomAppBar.dart';
import 'AddPharmacy_Controller.dart';
import '../../Widgets/CustomTextField.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';

class AddPharmacyScreen extends StatelessWidget {
  const AddPharmacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final controller = Get.put(AddPharmacyController());

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: CustomAppBar(title: "Add_pharmacy".tr),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
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
              Obx(() => Column(
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
                        onPressed: () => controller.removePhoneField(index),
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                          size: 28,
                        ),
                      )
                          : const SizedBox()
                    ],
                  ),
                ),
              )),
              CustomTextField(
                label: "Comments".tr,
                icon: Icons.notes,
                controller: controller.commentsController,
                keyboardType: TextInputType.text,
                maxLines: 3,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  height: 280,
                  child: Obx(
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
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ElevatedButton.icon(
                onPressed: controller.moveToCurrentLocation,
                icon: const Icon(
                  Icons.my_location,
                  color: AppColors.primaryColor,
                ),
                label: Text(
                  "LocationCreation".tr,
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
//AIzaSyBfbl2qUz2OBiqE5qa-FIB5b9QlT-5J8SU