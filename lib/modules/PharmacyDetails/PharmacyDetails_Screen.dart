import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import 'package:intellipharm/modules/PharmacyDetails/ColorClassHelper.dart';
import '../../Widgets/PharmacySummaryCard.dart';
import '../../app_theme/theme_extension.dart';

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
          return  Center(
            child: Text(
              "Failed to load pharmacy details",
              style: TextStyle(
                color: colors.textSecondary,
                fontFamily: 'Cairo'
              ),
            ),
          );
        }
        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(
                left: size.width * 0.04,
                right: size.width * 0.04,
                top: size.height * 0.01,
                bottom: size.height * 0.20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PharmacySummaryCard(
                    pharmacy: controller.pharmacyData.value,
                    controller: controller,
                    //showScheduledVisit: true,
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
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A2E5A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "Summarize Notes",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.tune,
                              size: 16,
                              color: Colors.grey,
                            ),
                            label: const Text(
                              "Filter",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.02),
                  controller.filteredNotes.isEmpty
                      ?  Center(
                          child: Text(
                            "No notes available for this pharmacy.",
                            style: TextStyle(
                                color: colors.textSecondary,
                                fontFamily: 'Cairo'
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.filteredNotes.length,
                          itemBuilder: (context, index) {
                            final note = controller.filteredNotes[index];
                            final cardBg = ColorClassHelper().getCardColor(
                              note.noteType,
                            );
                            final txtColor = ColorClassHelper().getTextColor(
                              note.noteType,
                            );
                            final tagBg = ColorClassHelper().getTagColor(
                              note.noteType,
                            );

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 5,
                                      backgroundColor: txtColor,
                                    ),
                                    if (index !=
                                        controller.filteredNotes.length - 1)
                                      Container(
                                        width: 2,
                                        height: size.height * 0.14,
                                        color: Colors.grey[300],
                                      ),
                                  ],
                                ),
                                SizedBox(width: size.width * 0.02),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      bottom: size.height * 0.009,
                                    ),
                                    padding: EdgeInsets.all(size.width * 0.03),
                                    decoration: BoxDecoration(
                                      color: cardBg,
                                      borderRadius: BorderRadius.circular(16),
                                      border: cardBg == Colors.white
                                          ? Border.all(
                                              color: Colors.grey.shade200,
                                            )
                                          : null,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 16,
                                              backgroundColor: const Color(
                                                0xFF0F2547,
                                              ),
                                              child: Text(
                                                note.authorName
                                                    .substring(
                                                      0,
                                                      note.authorName.length > 2
                                                          ? 2
                                                          : note
                                                                .authorName
                                                                .length,
                                                    )
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: size.width * 0.01),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    note.authorName,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: colors.textPrimary,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Team Member",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              note.createdAt.split(' ').first,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: size.height * 0.015),
                                        Text(
                                          note.content,
                                          style: TextStyle(
                                            fontSize: 13,
                                            height: 1.4,
                                            color: colors.textPrimary
                                                .withValues(alpha: 0.9),
                                          ),
                                        ),
                                        SizedBox(height: size.height * 0.015),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: tagBg.withValues(alpha: 0.4),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            note.noteType.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: txtColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        );
      }),
      //bottomNavigationBar: const AddNotesScreen(),
    );
  }
}
