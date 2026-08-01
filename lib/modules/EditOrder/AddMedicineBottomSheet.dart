import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/AppSnackBar.dart';
import '../../Widgets/MedicineCard.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import 'EditOrderController.dart';

class AddMedicineBottomSheet extends StatelessWidget {
  final EditOrderController controller;

  const AddMedicineBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.8,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.backgroundMain,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: size.width * 0.2,
            height:size.height * 0.004,
            margin: EdgeInsets.only(bottom: size.height * 0.02),
            decoration: BoxDecoration(
              color: colors.textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Text(
            "AddMedicineToOrder".tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          TextField(
            controller: searchController,
            style: TextStyle(color: colors.textPrimary, fontFamily: 'Cairo'),
            decoration: InputDecoration(
              hintText: "Search_medicines...".tr,
              hintStyle: TextStyle(
                color: colors.textSecondary,
                fontFamily: 'Cairo',
              ),
              prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
              filled: true,
              fillColor: colors.component,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (val) => controller.searchMedicinesToEdit(val),
          ),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: Obx(() {
              if (controller.isSearchingMedicines.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }
              if (controller.searchResults.isEmpty) {
                return Center(
                  child: Text(
                    "No_medicines_found".tr,
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                );
              }
              return ListView.builder(
                itemCount: controller.searchResults.length,
                itemBuilder: (context, index) {
                  final med = controller.searchResults[index];
                  return MedicineCard(
                    commercialName: med.commercialName,
                    scientificName: med.scientificName,
                    price: "PRICE_SP".trParams({'price': med.price.toString()}),
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
                    controller: controller.getMedicineQtyController(med.id),
                    onAdd: () {
                      final qtyController = controller.getMedicineQtyController(
                        med.id,
                      );
                      final qty = int.tryParse(qtyController.text) ?? 0;

                      if (qty > 0) {
                        controller.addNewMedicine(
                          med.id,
                          med.commercialName,
                          med.price.toString(),
                          qty,
                        );
                        qtyController.clear();
                        Get.back();
                        AppSnackBar.success("added_to_order".tr);
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
    );
  }
}
