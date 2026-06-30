
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/PharmacySummaryCard.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../PharmacyDetails/PharmacyDetails_Controller.dart';
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
          return const Center(child: Text("Failed to load pharmacy details"));
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
                          color: const Color(0xFF0F2547),
                        ),
                      ),
                      const SizedBox(width: 8),

                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E3A6C),
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
                        onPressed: () {},
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
                      color: colors.component.withValues(
                        alpha: 0.6,
                      ), // خلفية كارت فاتحة
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior:
                        Clip.antiAlias, // لقص الحواف ليتماشى مع الخط الجانبي
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: 5,
                            color: const Color(
                              0xFF00897B,
                            ), // الخط الجانبي الأخضر/التركوازي
                          ),
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

                  const SizedBox(height: 12),

                  // الكارت الثاني (ملاحظة الوقت)
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
                      color: const Color(0xFF0F2547),
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
                              color: const Color(0xFF80DEEA).withValues(
                                alpha: 0.7,
                              ), // تركوازي فاتح جداً ومريح للعين
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
                                const SizedBox(height: 8),
                                Text(
                                  "Closed Deal",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF006064),
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // زر لم يتم الاتفاق (No Deal)
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: size.height * 0.12,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFEF9A9A,
                              ).withValues(alpha: 0.4), // وردي/أحمر فاتح خفيف
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
                                const SizedBox(height: 8),
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
                  //const AddNotesScreen(),
                  SizedBox(height: size.height * 0.02),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colors.component,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 8),
                              _buildActiveTypeChip(
                                controller,
                                "GENERAL",
                                Colors.blue.shade50,
                                Colors.blue.shade700,
                              ),
                              const SizedBox(width: 8),
                              _buildActiveTypeChip(
                                controller,
                                "TIP",
                                const Color(0xFFE0F7F4),
                                const Color(0xFF00BFA5),
                              ),
                              const SizedBox(width: 8),
                              _buildActiveTypeChip(
                                controller,
                                "WARNING",
                                const Color(0xFFFDF2E9),
                                const Color(0xFFE67E22),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: TextField(
                                    controller: controller.textController,
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 14,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: "Add a note...",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontFamily: 'Cairo',
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Obx(() {
                                return GestureDetector(
                                  onTap: controller.isSendingNote.value
                                      ? null
                                      : () => controller.submitNewNote(),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF0F2547),
                                      shape: BoxShape.circle,
                                    ),
                                    child: controller.isSendingNote.value
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.send_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  BuildActionButtons()
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
      onTap: () =>
          controller.activeNoteType.value = type, // تعيين النوع النشط للإرسال
      child: Obx(() {
        bool isSelected = controller.activeNoteType.value == type;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(
                    color: textColor,
                    width: 2.0,
                  ) // حواف بارزة وعريضة عند الاختيار
                : Border.all(color: Colors.transparent, width: 2.0),
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
