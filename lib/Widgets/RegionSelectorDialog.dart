import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_theme/AppColors.dart';
import '../app_theme/theme_extension.dart';
import 'RegionSelector/RegionSelector_Controller.dart';


class RegionSelectorDialog extends StatelessWidget {
  const RegionSelectorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // 🟢 حقن RegionController
    final regionController = Get.put(RegionController());
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return Dialog(
      backgroundColor: colors.backgroundSecondary ?? const Color(0xFF1E272E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔍 حقل البحث عن المنطقة
            TextField(
              controller: regionController.searchController,
              onChanged: regionController.filter,
              style: TextStyle(color: colors.textDefault),
              decoration: InputDecoration(
                hintText: "Search...".tr,
                hintStyle: TextStyle(color: colors.textSecondary),
                prefixIcon: Icon(Icons.search, color: colors.textSecondary),
                filled: true,
                fillColor: colors.backgroundMain ?? const Color(0xFF12181B),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// 📌 خيار "كل المناطق" All Regions
            ListTile(
              dense: true,
              title: Text(
                "AllRegions".tr,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
              onTap: () {
                Get.back(result: null); // null تعني إلغاء فلترة المنطقة
              },
            ),
            const Divider(height: 1),

            /// 📜 قائمة المناطق
            Expanded(
              child: Obx(() {
                if (regionController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryColor),
                  );
                }

                if (regionController.filteredRegions.isEmpty) {
                  return Center(
                    child: Text(
                      "No_regions_found".tr,
                      style: TextStyle(color: colors.textSecondary),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: regionController.filteredRegions.length,
                  itemBuilder: (context, index) {
                    final region = regionController.filteredRegions[index];
                    return ListTile(
                      dense: true,
                      title: Text(
                        region.name,
                        style: TextStyle(
                          color: colors.textDefault,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      onTap: () {
                        regionController.selectRegion(region);
                      },
                    );
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