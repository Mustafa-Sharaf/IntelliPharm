
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
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(size.width * 0.03),
      height: size.height * 0.75,
      decoration: BoxDecoration(
        color: colors.backgroundMain,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // شريط البحث
          TextField(
            controller: controller.searchController,
            onChanged: controller.onSearchChanged,
            decoration: InputDecoration(
              hintText: "Search_pharmacy...".tr,
              hintStyle: const TextStyle(fontFamily: 'Cairo'),
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

          // قائمة الصيدليات
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
                return Center(
                  child: Text(
                    "No data found".tr,
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                );
              }

              return ListView.builder(
                controller: controller.scrollController,
                itemCount: controller.pharmacies.length + 1, // +1 لإظهار مؤشر التحميل بالأسفل
                itemBuilder: (context, index) {
                  // عند الوصول للنهاية وكان هناك جلب لصفحات أخرى
                  if (index == controller.pharmacies.length) {
                    return Obx(() => controller.isLoadingMore.value
                        ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    )
                        : const SizedBox.shrink());
                  }

                  final pharmacy = controller.pharmacies[index];

                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(
                        Icons.local_pharmacy,
                        color: AppColors.primaryColor,
                      ),
                      title: Text(
                        pharmacy.name,
                        style: const TextStyle(fontFamily: 'Cairo'),
                      ),
                      subtitle: Text(
                        pharmacy.region,
                        style: const TextStyle(fontFamily: 'Cairo'),
                      ),
                      onTap: () {
                        controller.selectPharmacy(pharmacy);
                        onSelected?.call(pharmacy);
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}