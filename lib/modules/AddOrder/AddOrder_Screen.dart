import 'package:flutter/material.dart';
import '../../Widgets/MedicineCard.dart';
import '../../app_theme/theme_extension.dart';
import '../Searching/Searching_Controller.dart';
import '../Searching/Searching_Screen.dart';


class AddOrderScreen extends StatelessWidget {
   AddOrderScreen({super.key});

  final searchController = SearchControllerX();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        backgroundColor: colors.backgroundMain,
        foregroundColor: colors.textPrimary,
        title: Row(
          children: [
            SizedBox(width: width * 0.25),
            Text(
              "Medicines",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Cairo',
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: width * 0.25),
            Stack(
              children: [
                Icon(Icons.shopping_cart_rounded,size: 30,),
                Positioned(
                  right: 2,
                  child: CircleAvatar(
                    radius: width * 0.013,
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding:EdgeInsets.all(width * 0.03),
        child: SingleChildScrollView(
          child: Column(
            children: [

              CustomSearchField(controller: searchController),

              const SizedBox(height: 10),

              MedicineCard(
                name: "Amoxicillin CL",
                description: "Antibiotic | 500mg Cap",
                price: "\$12.50",
                stockQuantity: "120",
                status: "مستورد",
                discount: "15% OFF",
                image: "assets/images/icon.png",
                controller: TextEditingController(),
                onAdd: () {
                  // add logic
                },
              ),
              MedicineCard(
                name: "Amoxicillin CL Amoxicillin CL Amoxicillin CL",
                description: "Antibiotic | 500mg Cap Amoxicillin CL Amoxicillin CL",
                price: "\$12.50sadfgh",
                stockQuantity: "120234567",
                status: "imported",
                discount: "15% OFF",
                image: "assets/images/LogoSmall.png",
                controller: TextEditingController(),
                onAdd: () {
                  // add logic
                },
              ),
              MedicineCard(
                name: "Amoxicillin CL",
                description: "Antibiotic | 500mg Cap",
                price: "\$12.50",
                stockQuantity: "120",
                status: "in stock",
                discount: "0",
                image: "assets/images/Franca.png",
                controller: TextEditingController(),
                onAdd: () {
                  // add logic
                },
              )
            ],
          ),
        )
      ),
    );
  }
}

/*

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/CustomAppBar.dart';
import '../../app_theme/theme_extension.dart';
import 'AddOrder_Controller.dart';
import '../../Widgets/CustomTextField.dart';
import '../../app_theme/AppColors.dart';

class AddOrderScreen extends StatelessWidget {
  const AddOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddOrderController());
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        controller.closeDropdown();
      },
      child: Scaffold(
        appBar: CustomAppBar(title: "Add_Order".tr),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              CustomTextField(
                label: "PharmacyName".tr,
                icon: Icons.local_pharmacy,
                controller: controller.pharmacyNameController,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: CustomTextField(
                      label: "Search_for_the_medicine".tr,
                      icon: Icons.search,
                      controller: controller.searchController,
                      //onChanged: controller.filterMedicines,
                      onChanged:controller.onSearchChanged,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                  Expanded(
                    flex: 1,
                    child: CustomTextField(
                      label: "Quantity".tr,
                      controller: controller.quantityController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => controller.tryAddOrder(),
                    ),
                  ),
                ],
              ),
              CustomTextField(
                label: "Comments".tr,
                icon: Icons.notes,
                controller: controller.commentController,
                keyboardType: TextInputType.text,
                maxLines: 2,
              ),

              Obx(
                () => controller.showDropdown.value
                    ? Container(
                        constraints: BoxConstraints(maxHeight: 200),
                        margin: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          color: colors.component,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: controller.isLoading.value
                            ? Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                itemCount: controller.medicines.length,
                                itemBuilder: (context, index) {
                                  final med = controller.medicines[index];
                                  return ListTile(
                                    title: Text(
                                      "${med.name}   ${med.price}  ${med.availableQuantity} ",
                                    ),
                                    onTap: () {
                                      controller.selectMedicine(med);
                                    },
                                  );
                                },
                              ),
                      )
                    : SizedBox(),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.48,
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.orders.length,
                    itemBuilder: (context, index) {
                      final order = controller.orders[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 3),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(order["name"]),
                            Text("x${order["qty"]}"),
                            Text("${order["price"] * order["qty"]} S.P"),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () => controller.removeOrder(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total".tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        SizedBox(width: 20),
                        Obx(
                          () => Text(
                            "${controller.totalPrice} S.P",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: Text(
                        "Send_Order".tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

/* Obx(
                () =>
                    controller.showDropdown.value &&
                        controller.filteredMedicines.isNotEmpty
                    ? Container(
                        constraints: BoxConstraints(maxHeight: 150),
                        margin: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ListView.builder(
                          itemCount: controller.filteredMedicines.length,
                          itemBuilder: (context, index) {
                            final med = controller.filteredMedicines[index];
                            return ListTile(
                              title: Text(med["name"] as String),
                              onTap: () {
                                controller.selectedMedicine.value = med;
                                controller.searchController.text =
                                    med["name"] as String;
                                controller.tryAddOrder();
                              },
                            );
                          },
                        ),
                      )
                    : SizedBox(),
              ),*/
