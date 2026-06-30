import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/PharmacySummaryCard.dart';
import '../../Widgets/NoteCardItem.dart';
import '../../app_theme/theme_extension.dart';
import '../AddNotes/AddNotes_Screen.dart';
import 'PharmacyDetails_Controller.dart';

class PharmacyDetailsScreen extends StatelessWidget {
  const PharmacyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final int pharmacyId = Get.arguments;
    final controller = Get.put(
      PharmacyDetailsController(),
      tag: pharmacyId.toString(),
    );

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        backgroundColor: colors.backgroundMain,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Pharmacy Details",
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Cairo',
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }
        final pharmacy = controller.pharmacyData.value;
        if (pharmacy == null) {
          return Center(
            child: Text(
              "Failed to load pharmacy details",
              style: TextStyle(
                color: colors.textSecondary,
                fontFamily: 'Cairo',
              ),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  left: size.width * 0.04,
                  right: size.width * 0.04,
                  top: size.height * 0.01,
                  bottom: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PharmacySummaryCard(
                      pharmacy: controller.pharmacyData.value,
                      controller: controller,
                    ),
                    SizedBox(height: size.height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Visit Notes",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            color: colors.textPrimary,
                          ),
                        ),
                        PopupMenuButton<String>(
                          color: colors.backgroundMain,
                          onSelected: (String value) {
                            controller.changeFilter(value);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              value: "ALL",
                              child: Text(
                                "ALL",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: colors.textDefault,
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: "GENERAL",
                              child: Text(
                                "GENERAL",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: colors.textDefault,
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: "WARNING",
                              child: Text(
                                "WARNING",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: colors.textDefault,
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: "TIP",
                              child: Text(
                                "TIP",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: colors.textDefault,
                                ),
                              ),
                            ),
                          ],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.tune,
                                  size: 16,
                                  color: colors.textSecondary,
                                ),
                                SizedBox(width: size.width * 0.02),
                                Text(
                                  controller.selectedFilter.value,
                                  style: TextStyle(
                                    color: colors.textSecondary,
                                    fontSize: 13,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),

                    controller.filteredNotes.isEmpty
                        ? Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.06,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.speaker_notes_off_outlined,
                                  size: 70,
                                  color: colors.textSecondary.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.02),
                                Text(
                                  "No notes available for this filter.",
                                  style: TextStyle(
                                    color: colors.textSecondary,
                                    fontFamily: 'Cairo',
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.filteredNotes.length,
                            itemBuilder: (context, index) {
                              return NoteCardItem(
                                note: controller.filteredNotes[index],
                                index: index,
                                totalItems: controller.filteredNotes.length,
                                size: size,
                                colors: colors,
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),

            const AddNotesScreen(),
          ],
        );
      }),
    );
  }
}
