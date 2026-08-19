import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/MedicineCard.dart';
import '../../app_theme/theme_extension.dart';
import '../NewOrder/NewOrder_Controller.dart';
import 'Alternatives_Controller.dart';


class AlternativesScreen extends StatelessWidget {
  final int medicineId;
  const AlternativesScreen({super.key, required this.medicineId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AlternativesController(medicineId), tag: medicineId.toString());
    final newOrderController = Get.find<NewOrderController>();
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar:AppBar(
        backgroundColor: colors.backgroundMain,
        foregroundColor: colors.textPrimary,
        title: Row(
          children: [
            SizedBox(width: size.width * 0.25),
            Text(
              "Alternatives".tr,
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
            }),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return  Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
        }

        if (controller.alternatives.isEmpty) {
          return Center(
            child: Text(
              "No_Alternatives_Available".tr,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 16,
                fontFamily: 'Cairo',
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.alternatives.length,
          itemBuilder: (context, index) {
            final med = controller.alternatives[index];
            final textController = controller.getController(med.id);

            return MedicineCard(
              medicineId: med.id,
              commercialName: med.commercialName,
              scientificName: med.scientificName,
              price: "PRICE_SP".trParams({'price': med.price.toString()}),
              stockQuantity: med.availableQuantity.toString(),
              status: med.isImported ? "Imported".tr : "Local".tr,
              discount: "",
              image: med.images.isNotEmpty
                  ? med.images.first
                  : "assets/images/medicine_Image.png",
              controller: textController,
              isImported: med.isImported,
              onAdd: () {
                final qty = int.tryParse(textController.text) ?? 0;
                if (qty > 0 && qty <= med.availableQuantity) {
                  newOrderController.addToCart(med, qty);
                  controller.decreaseStock(med.id, qty);
                  textController.clear();
                }
              },
              showAlternativesButton: false,
            );
          },
        );
      }),
    );
  }
}