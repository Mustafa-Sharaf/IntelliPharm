import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/BuildSelector.dart';
import '../../Widgets/CustomAppBar.dart';
import '../../Widgets/PharmacyCard.dart';
import '../../Widgets/RegionSelector/RegionSelector_Model.dart';
import '../../Widgets/RegionSelector/RegionSelector_Screen.dart';
import '../../app_theme/AppColors.dart';
import 'Pharmacists_Controller.dart';

class PharmacistsScreen extends StatelessWidget {
  const PharmacistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PharmacistsController());
    return Scaffold(
      appBar: CustomAppBar(title: "Pharmacists".tr),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () => BuildSelector(
                title: "Region".tr,
                value: controller.selectedRegion.value!.name,
                icon: Icons.map,
                onTap: () async {
                  final result = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (_) => RegionSelector(),
                  );
                  if (result != null && result is RegionModel) {
                    controller.selectedRegion.value = result;

                    controller.fetchPharmacies();
                  }
                },
                iconColor: AppColors.primaryColor,
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                }

                if (controller.pharmacies.isEmpty) {
                  return Center(child: Text("No_pharmacies_found".tr));
                }

                return ListView.builder(
                  itemCount: controller.pharmacies.length,
                  itemBuilder: (context, index) {
                    return PharmacyCard(pharmacy: controller.pharmacies[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
