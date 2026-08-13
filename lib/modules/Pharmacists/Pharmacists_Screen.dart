import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/PharmacyInfoCard.dart';
import '../../Widgets/Tabs.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../../helper/ContactLauncher/ContactLauncher.dart';
import '../PharmacyDetails/PharmacyDetails_Screen.dart';
import '../Searching/Searching_Controller.dart';
import '../Searching/Searching_Screen.dart';
import 'Pharmacists_Controller.dart';

class PharmacistsScreen extends StatelessWidget {
  PharmacistsScreen({super.key});
  final searchController = SearchControllerX();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final pharmacistsController = Get.find<PharmacistsController>();

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.03),
        child: Column(
          children: [
            /// SEARCH
            Row(
              children: [
                Expanded( // تغليف حقل البحث بـ Expanded ليملأ باقي المساحة المتاحة
                  child: CustomSearchField(
                    controller: searchController,
                    text: "Search_Pharmacists...".tr,
                    onChanged: (val) {
                      pharmacistsController.updateSearch(val);
                    },
                  ),
                ),
                SizedBox(width: size.width * 0.01),
                SizedBox(
                  width: size.width * 0.12,
                  height: size.width * 0.12,
                  child: ElevatedButton(
                    onPressed: () async {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.textPrimary,
                      elevation: 3,
                      padding: EdgeInsets.zero,
                      shape: const CircleBorder(),
                    ),
                    child: Icon(
                      Icons.tune,
                      color: AppColors.backgroundColorLight,
                      size: size.width * 0.06,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: size.height * 0.04),

            Obx(
              () => Tabs(
                tabs: pharmacistsController.tabs,
                selectedIndex: pharmacistsController.selectedTab.value,
                onTap: pharmacistsController.changeTab,
              ),
            ),
            SizedBox(height: size.height * 0.01),

            /// COUNT
            Obx(
              () => Row(
                children: [
                  Text(
                    "PHARMACIES_FOUND".trParams({
                      'count': pharmacistsController.filteredPharmacies.length
                          .toString(),
                    }),
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Cairo',
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.01),

            /// LIST
            Expanded(
              child: Obx(() {
                if (pharmacistsController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                }

                final list = pharmacistsController.filteredPharmacies;

                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      "No_pharmacies_found".tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Cairo',
                        color: colors.textSecondary,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: pharmacistsController.scrollController,
                  itemCount:
                      list.length +
                      (pharmacistsController.isMoreLoading.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    /// LOADING
                    if (index == list.length) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final pharmacy = list[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PharmacyInfoCard(
                        pharmacyName: pharmacy.name,
                        regionName: pharmacy.region,
                        openTime: pharmacy.openTime.length >= 5
                            ? pharmacy.openTime.substring(0, 5)
                            : pharmacy.openTime,
                        closeTime: pharmacy.closeTime.length >= 5
                            ? pharmacy.closeTime.substring(0, 5)
                            : pharmacy.closeTime,
                        pharmacistName: pharmacy.pharmacistName ?? "N/A",
                        isOpen: pharmacy.checkIsOpen,
                        onCartTap: () => Get.toNamed("/newOrderScreen"),
                        onContactTap: () =>
                            ContactLauncher().showContactOptions(
                              context,
                              pharmacy.pharmacistPhone,
                            ),
                        onDirectionsTap: () {
                          Get.toNamed("/activeOptimizedRouteTracking");
                        },
                        onViewNotesTap: () {
                          Get.to(
                            () => const PharmacyDetailsScreen(),
                            arguments: pharmacy.id,
                          );
                        },
                      ),
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
