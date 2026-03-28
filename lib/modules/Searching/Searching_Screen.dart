import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            SizedBox(height: 20),
            CustomTextField(
              label: "Search medicine...".tr,
              controller: controller.searchController,
              keyboardType: TextInputType.text,
              onChanged: controller.onSearchChanged,
              onSubmitted: (_) => controller.onSearchSubmit(),
              icon: Icons.search,
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.medicines.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.medication_outlined,
                        size: 60,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "No medicines found",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  );
                }

                return ListView.builder(
                  itemCount: controller.medicines.length,
                  itemBuilder: (context, index) {
                    final med = controller.medicines[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: colors.component,
                        boxShadow: [
                          BoxShadow(blurRadius: 6, color: Colors.black12),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(child: Text(med.name[0])),
                        title: Text(
                          med.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Price: ${med.price}"),
                            Text("Qty: ${med.quantity}"),
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
                            med.isImported ? "Imported" : "Local",
                            style: TextStyle(
                              color: med.isImported
                                  ? Colors.green
                                  : Colors.blue,
                              fontWeight: FontWeight.bold,
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
