import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/PharmacySummaryCard.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../AddNotes/AddNotes_Screen.dart';
import '../PharmacyDetails/PharmacyDetails_Controller.dart';
import '../PharmacyDetails/PharmacyDetails_Screen.dart';
import 'buildActionButtons.dart';

class VisitDetailsScreen extends StatelessWidget {
  const VisitDetailsScreen({super.key});

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
          "Visit Details",
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
          return const Center(
            child: Text(
              "Failed to load pharmacy details",
              style: TextStyle(fontFamily: 'Cairo'),
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
                  Row(
                    children: [
                      Text(
                        "Recent Notes",
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
                        child: const Text(
                          "2",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),

                      TextButton(
                        onPressed: () {
                          Get.to(()=> PharmacyDetailsScreen());
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: const Text(
                          "View All Notes",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Color(0xFF00897B),
                            fontSize: 14,
                            height: 1.1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colors.component.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior:Clip.antiAlias,
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(width: 5, color: const Color(0xFF00897B),),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.assignment_outlined,
                                    size: 20,
                                    color: Color(0xFF00897B),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      "Prefers oral antibiotics over injectables for general stock.",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF424242),
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: colors.component.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 20,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Best time: before 11 AM for procurement manager availability.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF424242),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    "Visit Actions",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Row(
                    children: [
                      // زر تم الاتفاق (Closed Deal)
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: size.height * 0.12,
                            decoration: BoxDecoration(
                              color: const Color(0xFF80DEEA).withValues(alpha: 0.7,),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_box_outlined,
                                  size: 24,
                                  color: Color(0xFF006064),
                                ),
                                 SizedBox(height: size.height * 0.013),
                                Text(
                                  "Closed Deal",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.05),
                      // زر لم يتم الاتفاق (No Deal)
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: size.height * 0.12,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF9A9A,).withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.cancel_outlined,
                                  size: 24,
                                  color: Color(0xFFC62828),
                                ),
                                SizedBox(height: size.height * 0.013),
                                Text(
                                  "No Deal",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFC62828),
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),
                  const AddNotesScreen(),
                  SizedBox(height: size.height * 0.02),
                  BuildActionButtons(),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildActiveTypeChip(
    PharmacyDetailsController controller,
    String type,
    Color bgColor,
    Color textColor,
  ) {
    return GestureDetector(
      onTap: () {},
      // controller.activeNoteType.value = type, // تعيين النوع النشط للإرسال
      child: Obx(() {
        //bool isSelected = controller.activeNoteType.value == type;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            /*border: isSelected
                ? Border.all(
                    color: textColor,
                    width: 2.0,
                  ) // حواف بارزة وعريضة عند الاختيار
                : Border.all(color: Colors.transparent, width: 2.0),*/
          ),
          child: Row(
            children: [
              CircleAvatar(radius: 3, backgroundColor: textColor),
              const SizedBox(width: 6),
              Text(
                type,
                style: TextStyle(
                  color: textColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
