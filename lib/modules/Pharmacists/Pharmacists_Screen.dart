import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/PharmacyInfoCard.dart';
import '../../Widgets/Tabs.dart';
import '../../app_theme/theme_extension.dart';
import '../../helper/ContactLauncher/ContactLauncher.dart';
import '../NewOrder/NewOrder_Screen.dart';
import '../Searching/Searching_Controller.dart';
import '../Searching/Searching_Screen.dart';
import 'Pharmacists_Controller.dart';

class PharmacistsScreen extends StatelessWidget {
  PharmacistsScreen({super.key});
  final searchController = SearchControllerX();
  final pharmacistsController = Get.put(PharmacistsController());

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.03),
        child: Column(
          children: [
            /// SEARCH
            CustomSearchField(controller: searchController),
            SizedBox(height: size.height * 0.04),

            /// TABS
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
                    //"${pharmacistsController.filteredPharmacies.length} pharmacies found",
                    "PHARMACIES_FOUND".trParams({
                      'count': pharmacistsController.filteredPharmacies.length.toString(),
                    }),
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Cairo',
                      color: colors.textSecondary,
                      //fontWeight: FontWeight.bold,
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
                  return const Center(child: CircularProgressIndicator());
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
                        //fontWeight: FontWeight.bold,
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
                        openTime: pharmacy.openTime.substring(0, 5),
                        closeTime: pharmacy.closeTime.substring(0, 5),
                        pharmacistName: pharmacy.pharmacistName ?? "N/A",
                        isOpen: pharmacy.checkIsOpen,
                        onCartTap: () => Get.to(() => NewOrderScreen()),
                        onContactTap: () =>
                            ContactLauncher().showContactOptions(
                              context,
                              pharmacy.pharmacistPhone,
                            ),
                        onDirectionsTap: () {},
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
