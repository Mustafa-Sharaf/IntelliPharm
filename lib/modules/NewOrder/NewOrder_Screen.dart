import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import 'package:intellipharm/modules/NewOrder/NewOrder_Controller.dart';
import '../../Widgets/AddMedicineButton.dart';
import '../../Widgets/MedicineItemCard.dart';
import '../../Widgets/PharmacySelector/PharmacyList_Controller.dart';
import '../../Widgets/PharmacySelector/PharmacySelector_Screen.dart';
import '../../app_theme/theme_extension.dart';

class NewOrderScreen extends StatelessWidget {
  const NewOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    final newOrderController = Get.find<NewOrderController>();
    final pharmacySelectorController = Get.find<PharmacySelectorController>();

    //  استخدام PopScope لإدارة زر الرجوع (AppBar أو إيماءة الهاتف)
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showExitConfirmation(context, newOrderController);
        if (shouldPop) {
          Get.back();
        }
      },
      child: Scaffold(
        backgroundColor: colors.backgroundMain,
        appBar: AppBar(
          backgroundColor: colors.backgroundMain,
          foregroundColor: colors.textPrimary,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final shouldPop = await _showExitConfirmation(context, newOrderController);
              if (shouldPop) {
                Get.back();
              }
            },
          ),
          title: Text(
            "NewOrder".tr,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Cairo',
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: colors.textSecondary, height: 1),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(size.width * 0.015),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "SELECT_PHARMACY".tr,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Cairo',
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              PharmacySelectorWidget(
                onSelected: (pharmacy) {
                  pharmacySelectorController.selectedPharmacy.value = pharmacy;
                },
              ),
              SizedBox(height: size.height * 0.015),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ORDER_ITEMS".tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Cairo',
                        color: colors.textSecondary,
                      ),
                    ),
                    Obx(
                      () => Text(
                        "ITEMS_COUNT".trParams({
                          'count': newOrderController.cart.length.toString(),
                        }),
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Cairo',
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.015),
              Expanded(
                child: Obx(() {
                  return ListView(
                    children: [
                      ...newOrderController.cart.map((item) {
                        return MedicineItemCard(
                          name: item.medicine.commercialName,
                          price: item.totalPrice,
                          unitPrice: item.medicine.price,
                          quantity: item.quantity,
                          onIncrease: () => newOrderController.increase(item),
                          onDecrease: () => newOrderController.decrease(item),
                          onRemove: () => newOrderController.removeItem(item),
                        );
                      }),
                      SizedBox(height: size.height * 0.01),
                      const AddMedicineButton(),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        "NOTES".tr,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                          vertical: size.height * 0.005,
                        ),
                        decoration: BoxDecoration(
                          color: colors.component,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: newOrderController.notesController,
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: colors.textDefault,
                          ),
                          decoration: InputDecoration(
                            hintText: "Add_optional_order_notes...".tr,
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Cairo',
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: size.height * 0.01),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.component,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "TotalPrice".tr,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          color: colors.textSecondary,
                        ),
                      ),
                      Text(
                        "PRICE_SP".trParams({
                          'price': newOrderController.totalPrice
                              .toStringAsFixed(0),
                        }),
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),

              /// Submit Button
              Obx(
                () => GestureDetector(
                  onTap: newOrderController.isSubmitting.value
                      ? null
                      : () {
                          newOrderController.submitOrder();
                          Get.back();
                        },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: newOrderController.isSubmitting.value
                          ? AppColors.primaryColor.withValues(alpha: 0.6)
                          : AppColors.primaryColor,
                    ),
                    child: Center(
                      child: newOrderController.isSubmitting.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "SubmitOrder".tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                                fontSize: 20,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmation(BuildContext context, NewOrderController controller) async {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    if (controller.cart.isEmpty) {
      return true;
    }

    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(
          "CONFIRM_EXIT".tr,
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w500,color: colors.textSecondary),
        ),
        content: Text(
          "DELETE_CART_QUESTION".tr,
          style: TextStyle(fontFamily: 'Cairo',color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              "No".tr,
              style: const TextStyle(fontFamily: 'Cairo', color: Colors.red,fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.cart.clear();
              controller.notesController.clear();
              Get.back(result: true);
            },
            child: Text(
              "Yes".tr,
              style: const TextStyle(fontFamily: 'Cairo', color: Colors.red,fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
