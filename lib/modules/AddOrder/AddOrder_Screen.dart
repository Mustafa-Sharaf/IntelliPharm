import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/CustomAppBar.dart';
import 'AddOrder_Controller.dart';
import '../../Widgets/CustomTextField.dart';
import '../../app_theme/AppColors.dart';

class AddOrderScreen extends StatelessWidget {
  const AddOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddOrderController());
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
                      onChanged: controller.filterMedicines,
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
