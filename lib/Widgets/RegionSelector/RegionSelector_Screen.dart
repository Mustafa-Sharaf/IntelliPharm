import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import 'RegionSelector_Controller.dart';

class RegionSelector extends StatelessWidget {
  RegionSelector({super.key});

  final controller = Get.put(RegionController());

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: MediaQuery.of(context).size.width * 0.02,
        right: MediaQuery.of(context).size.width * 0.02,
        top: MediaQuery.of(context).size.width * 0.02,
      ),

      child: SizedBox(

        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            TextField(
              controller: controller.searchController,
              onChanged: controller.filter,
              decoration: InputDecoration(
                hintText: "Search_for_an_area...".tr,
                hintStyle: TextStyle(fontFamily: 'Cairo'),
                prefixIcon: Icon(Icons.search,color: AppColors.primaryColor),
                filled: true,
                fillColor: colors.component,
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.filteredRegions.length,
                  itemBuilder: (context, index) {
                    final region = controller.filteredRegions[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: ListTile(
                        leading: Icon(
                          Icons.location_city,
                          color: AppColors.primaryColor,
                        ),
                        title: Text(
                          region.name,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () => controller.selectRegion(region),

                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
