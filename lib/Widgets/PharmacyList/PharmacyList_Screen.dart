import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import 'PharmacyList_Controller.dart';

class PharmacySelectorWidget extends StatelessWidget {
  PharmacySelectorWidget({super.key});

  final controller = Get.put(PharmacySelectorController());

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return Obx(() {
      final pharmacy = controller.selectedPharmacy.value;

      return InkWell(
        onTap: () => _showPharmacyBottomSheet(context),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: colors.component,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pharmacy?.name ?? "Select Pharmacy",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      pharmacy?.region ?? "",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showPharmacyBottomSheet(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: colors.backgroundMain,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            TextField(
              controller: controller.searchController,
              onChanged: controller.filter,
              decoration: InputDecoration(
                hintText: "Search pharmacy...",
                prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
                filled: true,
                fillColor: colors.component,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.filteredPharmacies.length,
                  itemBuilder: (context, index) {
                    final pharmacy = controller.filteredPharmacies[index];

                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.local_pharmacy,
                          color: AppColors.primaryColor,
                        ),
                        title: Text(
                          pharmacy.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(pharmacy.region),
                        onTap: () => controller.selectPharmacy(pharmacy),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
