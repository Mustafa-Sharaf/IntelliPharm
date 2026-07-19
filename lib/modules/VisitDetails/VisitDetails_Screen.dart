import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/PharmacySummaryCard.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../AddNotes/AddNotes_Screen.dart';
import '../PharmacyDetails/PharmacyDetails_Controller.dart';
import '../PharmacyDetails/PharmacyDetails_Screen.dart';
import 'ActionDealButton.dart';
import 'VisitDetails_Controller.dart';
import 'VisitNoteCard.dart';
import 'BuildActionButtons.dart';

class VisitDetailsScreen extends StatelessWidget {
  const VisitDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final Map<String, dynamic> args = Get.arguments;
    final int pharmacyId = args["pharmacyId"];
    final int visitId = args["visitId"];
    final controller = Get.put(
      PharmacyDetailsController(),
      tag: pharmacyId.toString(),
    );
    final visitDetailsController = Get.put(VisitDetailsController());

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        backgroundColor: colors.backgroundMain,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        title: Text(
          "VisitDetails".tr,
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
              "Failed_to_load_pharmacy_details",
              style: TextStyle(fontFamily: 'Cairo',color: colors.textPrimary,),
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
                    showScheduledVisit: true,
                    showPharmacistInfo: false,
                  ),
                  SizedBox(height: size.height * 0.01),
                  /// SECTION: RECENT NOTES HEADER
                  Row(
                    children: [
                      Text(
                        "RecentNotes".tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                          fontFamily: 'Cairo',
                          color: colors.textPrimary,
                        ),
                      ),
                      SizedBox(width: size.width * 0.04),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colors.textPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "${pharmacy.historyNotes.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Get.to(
                            () => const PharmacyDetailsScreen(),
                            arguments: pharmacyId,
                          );
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Text(
                          "ViewAllNotes".tr,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 14,
                            height: 1.1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  if (pharmacy.historyNotes.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.03,
                      ),
                      decoration: BoxDecoration(
                        color: colors.component.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.note_alt_outlined,
                            size: 40,
                            color: colors.textPrimary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "No_notes_available_for_this_pharmacy_yet.".tr,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              color: colors.textPrimary.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...pharmacy.historyNotes.reversed.take(2).map((note) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.01),
                        child: VisitNoteCard(
                          text: note.content,
                          backgroundColor: colors.component.withValues(
                            alpha: 0.6,
                          ),
                          isGeneralNote:note.noteType.toLowerCase() == "general",
                        ),
                      );
                    }),

                  Text(
                    "Visit_Actions".tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                  Obx(() {
                    if (visitDetailsController.isSubmittingCheck.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }
                    return Row(
                      children: [
                        ActionDealButton(
                          title: "ClosedDeal".tr,
                          icon: Icons.check_box_outlined,
                          iconColor: AppColors.primaryColor,
                          textColor: AppColors.primaryColor,
                          backgroundColor: const Color(
                            0xFF80DEEA,
                          ).withValues(alpha: 0.7),
                          onTap: () async {
                            await visitDetailsController.submitVisitCheck(
                              visitId: visitId,
                              isUseful: true,
                            );
                            if (context.mounted) {
                              Navigator.pop(context, true);
                            }
                          },
                        ),
                        SizedBox(width: size.width * 0.05),
                        ActionDealButton(
                          title: "NoDeal".tr,
                          icon: Icons.cancel_outlined,
                          iconColor: const Color(0xFFC62828),
                          textColor: const Color(0xFFC62828),
                          backgroundColor: const Color(
                            0xFFEF9A9A,
                          ).withValues(alpha: 0.4),
                          onTap: () async {
                            await visitDetailsController.submitVisitCheck(
                              visitId: visitId,
                              isUseful: false,
                            );

                            if (context.mounted) {
                              Navigator.pop(context, true);
                            }
                          },
                        ),
                      ],
                    );
                  }),
                  SizedBox(height: size.height * 0.02),
                  //const AddNotesScreen(),
                  AddNotesScreen(),
                  SizedBox(height: size.height * 0.02),
                  BuildActionButtons(pharmacy: pharmacy),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
