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
            const SizedBox(height: 20),

            /// 🔍 Search Field
            CustomTextField(
              label: "Search medicine...".tr,
              controller: controller.searchController,
              keyboardType: TextInputType.text,
              onChanged: controller.onSearchChanged,
              icon: Icons.search,
            ),

            /// 📦 CONTENT
            Expanded(
              child: Obx(() {
                /// =========================
                /// 💤 حالة البداية
                /// =========================
                if (controller.searchText.value.isEmpty) {
                  return const Center(
                    child: Text(
                      "Start typing to search",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                /// =========================
                /// 🔄 Loading أولي
                /// =========================
                if (controller.isLoading.value &&
                    controller.medicines.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                /// =========================
                /// 🔍 Suggestions (مثل Google)
                /// =========================
                if (controller.suggestions.isNotEmpty &&
                    controller.medicines.isEmpty) {
                  return ListView.builder(
                    itemCount: controller.suggestions.length,
                    itemBuilder: (context, index) {
                      final med = controller.suggestions[index];

                      return ListTile(
                        leading: const Icon(Icons.search),
                        title: Text(med.name),
                        onTap: () => controller.onSuggestionTap(med),
                      );
                    },
                  );
                }

                /// =========================
                /// ❌ لا يوجد نتائج
                /// =========================
                if (controller.medicines.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.medication_outlined,
                          size: 60, color: Colors.grey),
                      SizedBox(height: 10),
                      Text("No medicines found",
                          style: TextStyle(color: Colors.grey)),
                    ],
                  );
                }

                /// =========================
                /// 📋 LIST + Infinite Scroll
                /// =========================
                return ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.medicines.length + 1,
                  itemBuilder: (context, index) {
                    /// 🔽 Loader تحت
                    if (index == controller.medicines.length) {
                      return Obx(() => controller.isLoadingMore.value
                          ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                            child: CircularProgressIndicator()),
                      )
                          : const SizedBox());
                    }

                    final med = controller.medicines[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: med.inStock
                            ? colors.component
                            : Colors.grey.shade200,
                        boxShadow: const [
                          BoxShadow(blurRadius: 6, color: Colors.black12),
                        ],
                      ),
                      child: ListTile(
                        leading:
                        CircleAvatar(child: Text(med.name[0])),

                        title: Text(
                          med.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),

                        subtitle: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text("Price: ${med.price}"),
                            Text("Qty: ${med.quantity}"),

                            /// 🔥 حالة المخزون
                            if (!med.inStock)
                              const Text(
                                "Out of stock",
                                style: TextStyle(color: Colors.red),
                              ),
                          ],
                        ),

                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: med.isImported
                                ? Colors.green.shade100
                                : Colors.blue.shade100,
                            borderRadius:
                            BorderRadius.circular(10),
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