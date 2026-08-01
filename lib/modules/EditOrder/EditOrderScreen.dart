import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import 'AddMedicineBottomSheet.dart';
import 'EditOrderController.dart';

class EditOrderScreen extends StatelessWidget {
  final int orderId;

  const EditOrderScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final controller = Get.find<EditOrderController>(tag: orderId.toString());

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        backgroundColor: colors.backgroundMain,
        foregroundColor: colors.textPrimary,
        centerTitle: true,
        title: Text(
          "EditOrder".tr,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }
        return Column(
          children: [
            Expanded(
              child: controller.items.isEmpty
                  ? Center(
                      child: Text(
                        "No_items_in_order".tr,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: controller.items.length,
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        final item = controller.items[index];
                        return Card(
                          color: colors.component,
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.medicineName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: colors.textPrimary,
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                       SizedBox(height: 4),
                                      Text(
                                        "${item.unitPrice} \$",
                                        style: TextStyle(
                                          color: colors.textSecondary,
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.red,
                                      ),
                                      onPressed: () =>
                                          controller.decrementQuantity(item),
                                    ),
                                    Obx(
                                      () => Text(
                                        '${item.quantity.value}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: colors.textPrimary,
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                        color: Colors.green,
                                      ),
                                      onPressed: () =>
                                          controller.incrementQuantity(item),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => controller.removeItem(item),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                  side: BorderSide(color: AppColors.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  controller.searchMedicinesToEdit('');
                  Get.bottomSheet(
                    AddMedicineBottomSheet(controller: controller),
                    isScrollControlled: true,
                  );
                },
                icon: Icon(Icons.add, color: AppColors.primaryColor),
                label: Text(
                  "AddNewMedicine".tr,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              color: colors.component,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => controller.submitUpdate(),
                child: Text(
                  "SaveChanges".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

