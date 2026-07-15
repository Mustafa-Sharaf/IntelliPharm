import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import 'PharmacyList_Controller.dart';
import 'PharmacySelector_Model.dart';

class PharmacyBottomSheet extends StatelessWidget {
  final Function(PharmacyModel pharmacy)? onSelected;

  PharmacyBottomSheet({super.key, this.onSelected});

  final controller = Get.find<PharmacySelectorController>();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size=MediaQuery.of(context).size;

    return Container(
      padding:  EdgeInsets.all(size.width * 0.02),
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
              hintText: "Search_pharmacy...".tr,
              hintStyle: TextStyle(fontFamily: 'Cairo'),
              prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
              filled: true,
              fillColor: colors.component,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

           SizedBox(height: size.height * 0.015),

          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ?  Center(child: CircularProgressIndicator(color: AppColors.primaryColor,))
                  : ListView.builder(
                      itemCount: controller.filteredPharmacies.length,
                      itemBuilder: (context, index) {
                        final pharmacy = controller.filteredPharmacies[index];

                        return Card(
                          elevation: 0,
                          child: ListTile(
                            leading: Icon(
                              Icons.local_pharmacy,
                              color: AppColors.primaryColor,
                            ),
                            title: Text(pharmacy.name,style: TextStyle(fontFamily: 'Cairo'),),
                            subtitle: Text(pharmacy.region,style: TextStyle(fontFamily: 'Cairo'),),
                            onTap: () {
                              controller.selectPharmacy(pharmacy);
                              onSelected?.call(pharmacy);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
