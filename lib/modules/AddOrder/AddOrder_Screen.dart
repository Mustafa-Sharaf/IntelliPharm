import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/Tabs.dart';
import '../NewOrder/NewOrder_Controller.dart';
import '../../Widgets/MedicineCard.dart';
import '../../app_theme/theme_extension.dart';
import '../Searching/Searching_Controller.dart';
import '../Searching/Searching_Screen.dart';
import 'AddOrder_Controller.dart';
import 'CategoryFilterMenu.dart';

class AddOrderScreen extends StatelessWidget {
  AddOrderScreen({super.key});

  final searchController = SearchControllerX();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final newOrderController = Get.find<NewOrderController>();
    final addOrderController = Get.find<AddOrderController>();

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        backgroundColor: colors.backgroundMain,
        foregroundColor: colors.textPrimary,
        title: Row(
          children: [
            SizedBox(width: size.width * 0.25),
            Text(
              "Medicines".tr,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Cairo',
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: size.width * 0.25),
            Obx(() {
              final count = newOrderController.cart.length;
              return GestureDetector(
                onTap: () {
                  //Get.to(() => NewOrderScreen());
                  Get.toNamed("/newOrderScreen");
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart_rounded, size: 28),
                    if (count > 0)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: AnimatedScale(
                          scale: count > 0 ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                count > 99 ? '99+' : '$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            })
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.03),
        child: Column(
          children: [
            /// Row Search & Filter Button
            Row(
              children: [
                CustomSearchField(
                  controller: searchController,
                  text: "Search_medicines...".tr,
                  onChanged: (val) {
                    addOrderController.onSearchChanged(val);
                  },
                  onClear: () {
                    addOrderController.onSearchChanged('');
                  },
                ),
                SizedBox(width: size.width * 0.01),
                const CategoryFilterMenu(),
              ],
            ),
            SizedBox(height: size.height * 0.015),

            /// TABS for Types (All / Local / Imported)
            Obx(
              () => Tabs(
                tabs: ["All".tr, "Local".tr, "Imported".tr],
                selectedIndex: addOrderController.selectedTypeTab.value,
                onTap: addOrderController.changeTypeTab,
              ),
            ),
            SizedBox(height: size.height * 0.015),

            /// MEDICINES LIST
            Expanded(
              child: Obx(() {
                if (addOrderController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                }

                return ListView.builder(
                  controller: addOrderController.scrollController,
                  itemCount:
                      addOrderController.medicines.length +
                      (addOrderController.isPaginationLoading.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == addOrderController.medicines.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      );
                    }

                    final med = addOrderController.medicines[index];
                    return MedicineCard(
                      commercialName: med.commercialName,
                      scientificName: med.scientificName,
                      price: "PRICE_SP".trParams({
                        'price': med.price.toString(),
                      }),
                      stockQuantity: med.availableQuantity.toString(),
                      status: med.isImported ? "Imported".tr : "Local".tr,
                      discount:
                          (med.gift != null &&
                              med.gift!.giftQuantity > 0 &&
                              med.gift!.requiredQuantity > 0)
                          ? "GIFT_PROMO".trParams({
                              'required_qty': med.gift!.requiredQuantity
                                  .toString(),
                              'gift_qty': med.gift!.giftQuantity.toString(),
                            })
                          : "",
                      image: med.images.isNotEmpty
                          ? med.images.first
                          : "assets/images/icon.png",
                      controller: addOrderController.getController(med.id),
                      onAdd: () {
                        final controller = addOrderController.getController(
                          med.id,
                        );
                        final qty = int.tryParse(controller.text) ?? 0;

                        if (qty > 0) {
                          newOrderController.addToCart(med, qty);
                          controller.clear();
                        }
                      },
                      isImported: med.isImported,
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
