import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/CustomTextField.dart';
import '../../app_theme/theme_extension.dart';
import 'Searching_Controller.dart';

class MedicineSearchSheet extends StatelessWidget {
  MedicineSearchSheet({super.key});

  final controller = Get.put(SearchingController());

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            /// Search Field
            CustomTextField(
              label: "Search medicine...".tr,
              controller: controller.searchController,
              keyboardType: TextInputType.text,
              onChanged: controller.onSearchChanged,
              icon: Icons.search,
            ),

            /// CONTENT
            Expanded(
              child: Obx(() {
                if (controller.searchText.value.isEmpty) {
                  return Center(
                    child: Text(
                      "Start_typing_to_search".tr,
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Cairo',),
                    ),
                  );
                }
                if (controller.isLoading.value &&
                    controller.medicines.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                }
                if (controller.suggestions.isNotEmpty &&
                    controller.medicines.isEmpty) {
                  return ListView.builder(
                    itemCount: controller.suggestions.length,
                    itemBuilder: (context, index) {
                      final med = controller.suggestions[index];

                      return ListTile(
                        leading: const Icon(Icons.search),
                        title: Text(med.name,style: TextStyle(fontFamily: 'Cairo',),),
                        onTap: () => controller.onSuggestionTap(med),
                      );
                    },
                  );
                }
                if (controller.medicines.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.medication_outlined,
                        size: 60,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Text(
                        "No_medicines_found".tr,
                        style: TextStyle(color: Colors.grey,
                          fontFamily: 'Cairo',),
                      ),
                    ],
                  );
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.medicines.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.medicines.length) {
                      return Obx(
                        () => controller.isLoadingMore.value
                            ? Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      );
                    }

                    final med = controller.medicines[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: colors.component,
                        boxShadow: const [
                          BoxShadow(blurRadius: 6, color: Colors.black12),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primaryColor,
                            child: Text(
                                med.name[0],style: TextStyle(
                              fontFamily: 'Cairo',

                            ),
                            )),

                        title: Text(
                          med.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',),
                        ),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Price: ${med.price}",style: TextStyle(fontFamily: 'Cairo',),),
                            Text("Qty: ${med.quantity}",style: TextStyle(fontFamily: 'Cairo',),),

                            if (!med.inStock)
                              Text(
                                "Out_of_stock".tr,
                                style: TextStyle(color: Colors.red,fontFamily: 'Cairo',),
                              ),
                          ],
                        ),

                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: med.isImported
                                ? Colors.green.shade100
                                : Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            med.isImported ? "Imported".tr : "Local".tr,
                            style: TextStyle(
                              color: med.isImported
                                  ? Colors.green
                                  : Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),

                        onTap: () {
                          Get.back(result: med);
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
