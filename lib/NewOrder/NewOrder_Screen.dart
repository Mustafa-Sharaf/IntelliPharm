import 'package:flutter/material.dart';
import '../Widgets/CustomTextField.dart';
import '../Widgets/MedicineItemCard.dart';
import '../app_theme/theme_extension.dart';

class NewOrderScreen extends StatelessWidget {
  const NewOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final width = MediaQuery.of(context).size.width;
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
           /* Text(
              "Select Pharmacy",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Cairo',
                color: colors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),*/
            CustomTextField(
              label: "Enter name pharmacy",
              icon: Icons.add_circle,
              //controller: controller.pharmacistsNameController,
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8),
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
            SizedBox(height: 10,),
            MedicineItemCard(
              name: "Amoxicillin CL",
              price: 25.00,
              unitPrice: 12.50,
              quantity: 1002,
              onIncrease: () {
                // زيادة الكمية
              },
              onDecrease: () {
                // تقليل الكمية
              },
              onRemove: () {
                // حذف العنصر
              },
            ),
          ],
        ),
      ),
    );
  }
}
