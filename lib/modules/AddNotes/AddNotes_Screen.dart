/*


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_theme/theme_extension.dart';



class AddNotesScreen extends StatelessWidget {
  const AddNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    return  Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
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
                  _buildFilterChip(
                    "GENERAL",
                    Colors.blue.shade50,
                    Colors.blue.shade700,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    "TIP",
                    const Color(0xFFE0F7F4),
                    const Color(0xFF00BFA5),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
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
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: "Add a note...",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
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
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F2547),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
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

  Widget _buildFilterChip(
      String type,
      Color bgColor,
      Color textColor,
      ) {
    return GestureDetector(
      onTap: () => controller.selectedFilter.value = type,
      child: Obx(() {
        bool isSelected = controller.selectedFilter.value == type;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: textColor, width: 1.5)
                : null,
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
*/
/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_theme/theme_extension.dart';
import '../PharmacyDetails_Controller.dart';

class AddNotesScreen extends StatelessWidget {
  const AddNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final controller = Get.find<PharmacyDetailsController>();
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
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
*/
