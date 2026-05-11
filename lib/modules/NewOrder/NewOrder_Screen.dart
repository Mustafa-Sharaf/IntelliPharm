import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/AddMedicineButton.dart';
import '../../Widgets/CustomTextField.dart';
import '../../Widgets/MedicineItemCard.dart';
import '../../app_theme/theme_extension.dart';
import '../AddOrder/AddOrder_Controller.dart';

/*
class NewOrderScreen extends StatelessWidget {
  const NewOrderScreen({super.key});

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(
              label: "Enter name pharmacy",
              icon: Icons.add_circle,
              //controller: controller.pharmacistsNameController,
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
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
                  Text(
                    "2 Items",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Cairo',
                      color: colors.textPrimary,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  MedicineItemCard(
                    name: "Amoxicillin CL",
                    price: 25.00,
                    unitPrice: 12.50,
                    quantity: 1002,
                    onIncrease: () {},
                    onDecrease: () {},
                    onRemove: () {},
                  ),
                  MedicineItemCard(
                    name: "Amoxicillin CL",
                    price: 25.00,
                    unitPrice: 12.50,
                    quantity: 1002,
                    onIncrease: () {},
                    onDecrease: () {},
                    onRemove: () {},
                  ),
                  MedicineItemCard(
                    name: "Amoxicillin CL",
                    price: 25.00,
                    unitPrice: 12.50,
                    quantity: 1002,
                    onIncrease: () {},
                    onDecrease: () {},
                    onRemove: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AddMedicineButton(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          vertical:
                              size.height *
                              0.005, // 🔥 خففناها ليتناسب مع TextField
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
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
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.02,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.primaryColor,
                      ),
                      child: Center(
                        child: Text(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
class NewOrderScreen extends StatelessWidget {
  NewOrderScreen({super.key});

  final controller = Get.find<AddOrderController>();

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
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
                  Obx(() => Text(
                    "${controller.cart.length} Items",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Cairo',
                      color: AppColors.primaryColor,
                    ),
                  ))
                ],
              ),
            ),

            SizedBox(height: 10),



            SizedBox(height: 10),

            /// CART LIST
            Expanded(
              child: Obx(() {
                return ListView(
                  children: [
                    ...controller.cart.map((item) {
                      return MedicineItemCard(
                        name: item.medicine.commercialName,
                        price: item.totalPrice,
                        unitPrice: item.medicine.price,
                        quantity: item.quantity,
                        onIncrease: () => controller.increase(item),
                        onDecrease: () => controller.decrease(item),
                        onRemove: () => controller.removeItem(item),
                      );
                    }),

                    const SizedBox(height: 10),
                    const AddMedicineButton(),
                  ],
                );
              }),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    vertical:
                    size.height *
                        0.005, // 🔥 خففناها ليتناسب مع TextField
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
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
            ),

            SizedBox(height: 10),

            /// SUBMIT
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.02,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.primaryColor,
                ),
                child: Center(
                  child: Text(
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
          ],
        ),
      ),
    );
  }
}