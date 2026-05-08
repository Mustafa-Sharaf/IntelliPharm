import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/Tabs.dart';
import '../NewOrder/NewOrder_Screen.dart';
import '../../Widgets/MedicineCard.dart';
import '../../app_theme/theme_extension.dart';
import '../Searching/Searching_Controller.dart';
import '../Searching/Searching_Screen.dart';
import 'AddOrder_Controller.dart';

class AddOrderScreen extends StatelessWidget {
  AddOrderScreen({super.key});

  final searchController = SearchControllerX();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final addOrderController = Get.put(AddOrderController());
    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        backgroundColor: colors.backgroundMain,
        foregroundColor: colors.textPrimary,
        title: Row(
          children: [
            SizedBox(width: size.width * 0.25),
            Text(
              "Medicines",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Cairo',
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: size.width * 0.25),
            GestureDetector(
              onTap: () {
                Get.to(() => NewOrderScreen());
              },
              child: Stack(
                children: [
                  Icon(Icons.shopping_cart_rounded, size: 30),
                  Positioned(
                    right: 2,
                    child: CircleAvatar(
                      radius: size.width * 0.013,
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.03),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomSearchField(controller: searchController),
              SizedBox(height: size.height * 0.025),

              Obx(
                    () => Tabs(
                  tabs: addOrderController.categories.map((e) => e.name).toList(),
                  selectedIndex: addOrderController.selectedTab.value,
                  onTap: addOrderController.changeTab,
                ),
              ),
              SizedBox(height: size.height * 0.025),
              Obx(() {
                if (addOrderController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: addOrderController.medicines.length,
                  itemBuilder: (context, index) {
                    final med = addOrderController.medicines[index];

                    return MedicineCard(
                      commercialName: med.commercialName,
                      scientificName: med.scientificName,
                      price: "${med.price.toString()} S.P",
                      stockQuantity: med.availableQuantity.toString(),
                      status: med.isImported ? "imported" : "local",
                      discount: "15% OFF",
                      image: "assets/images/icon.png",
                      controller: TextEditingController(),
                      onAdd: () {},
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
