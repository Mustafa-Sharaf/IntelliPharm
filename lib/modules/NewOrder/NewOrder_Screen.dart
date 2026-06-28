import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import 'package:intellipharm/modules/NewOrder/NewOrder_Controller.dart';
import '../../Widgets/AddMedicineButton.dart';
import '../../Widgets/MedicineItemCard.dart';
import '../../Widgets/PharmacySelector/PharmacyList_Controller.dart';
import '../../Widgets/PharmacySelector/PharmacySelector_Screen.dart';
import '../../app_theme/theme_extension.dart';
import '../AddOrder/AddOrder_Controller.dart';

class NewOrderScreen extends StatelessWidget {
  NewOrderScreen({super.key});

  final controller = Get.find<AddOrderController>();
  final newOrderController = Get.find<NewOrderController>();
  //final pharmacySelectorController = Get.put(PharmacySelectorController(), permanent: true,);
  final pharmacySelectorController = Get.find<PharmacySelectorController>();
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        backgroundColor: colors.backgroundMain,
        foregroundColor: colors.textPrimary,
        centerTitle: true,
        title: Text(
          "New Order",
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
        padding: EdgeInsets.only(
          left: size.width * 0.03,
          right: size.width * 0.03,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(size.width * 0.015),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "SELECT PHARMACY",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Cairo',
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            //PharmacySelectorWidget(),
            PharmacySelectorWidget(
              onSelected: (pharmacy) {
                pharmacySelectorController.selectedPharmacy.value = pharmacy;
              },
            ),
            SizedBox(height: size.height * 0.015),
            Padding(
              padding: EdgeInsets.only(
                left: size.width * 0.03,
                right: size.width * 0.03,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ORDER ITEMS",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      color: colors.textSecondary,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(
                    () => Text(
                      "${newOrderController.cart.length} Items",
                      style: TextStyle(
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
                    const Text(
                      "NOTES",
                      style: TextStyle(
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
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Add optional order notes...",
                          hintStyle: TextStyle(
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
                      "Total Price",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        color: colors.textSecondary,
                      ),
                    ),
                    Text(
                      "${newOrderController.totalPrice.toStringAsFixed(0)} S.P",
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

            GestureDetector(
              onTap: () {
                newOrderController.submitOrder();
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.primaryColor,
                ),
                child: Center(
                  child: Obx(
                    () => newOrderController.isSubmitting.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Submit Order",
                            style: TextStyle(
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
    );
  }
}
