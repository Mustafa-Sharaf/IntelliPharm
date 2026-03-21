import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/modules/AddOrder/AddOrder_Controller.dart';
import '../../Widgets/CustomTextField.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';

class AddOrderScreen extends StatelessWidget {
  const AddOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final controller = Get.put(AddOrderController());
    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        title: Text(
          "Add_Order".tr,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      body:Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
        child: Column(
          children: [
            CustomTextField(
              label: "PharmacyName".tr,
              icon: Icons.local_pharmacy,
              controller: controller.pharmacyNameController,
            ),

          ],
        ),
      )
    );
  }
}
