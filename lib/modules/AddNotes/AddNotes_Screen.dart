import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_theme/theme_extension.dart';
import 'AddNotes_Controller.dart';

class AddNotesScreen extends StatelessWidget {
  const AddNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final controller = Get.find<AddNotesController>();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SizedBox(width: size.width * 0.04),
                _buildFilterChip(
                  controller,
                  typeKey: "general",
                  label: "GENERAL".tr,
                  lightBgColor: Colors.blue.shade50,
                  textColor: Colors.blue.shade700,
                  darkBgColor: const Color(0xFF1A2638),
                ),
                SizedBox(width: size.width * 0.04),
                _buildFilterChip(
                  controller,
                  typeKey: "tip",
                  label: "TIP".tr,
                  lightBgColor: const Color(0xFFE0F7F4),
                  textColor: const Color(0xFF00BFA5),
                  darkBgColor: const Color(0xFF163331),
                ),
                SizedBox(width: size.width * 0.04),
                _buildFilterChip(
                  controller,
                  typeKey: "warning",
                  label: "WARNING".tr,
                  lightBgColor: const Color(0xFFFDF2E9),
                  textColor: const Color(0xFFE67E22),
                  darkBgColor: const Color(0xFF382920),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.textSecondary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: controller.textController,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: TextStyle(
                        color: colors.textDefault,
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        decoration: TextDecoration.none,
                      ),
                      decoration: InputDecoration(
                        hintText: "AddANote".tr,
                        hintStyle: TextStyle(
                          color: colors.textDefault,
                          fontSize: 14,
                          fontFamily: 'Cairo',
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.04),
                Obx(
                  () => GestureDetector(
                    onTap: controller.isSubmitting.value
                        ? null
                        : () => controller.submitNote(),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colors.textPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: controller.isSubmitting.value
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
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    AddNotesController controller, {
    required String typeKey,
    required String label,
    required Color lightBgColor,
    required Color textColor,
    required Color darkBgColor,
  }) {
    return Obx(() {
      final isDarkMode = Get.isDarkMode;

      bool isSelected = controller.selectedType.value == typeKey;
      Color computedBg = isDarkMode ? darkBgColor : lightBgColor;

      return GestureDetector(
        onTap: () {
          controller.changeSelectedType(typeKey);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? computedBg : computedBg.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: textColor, width: 1.5)
                : Border.all(color: Colors.transparent, width: 1.5),
          ),
          child: Row(
            children: [
              CircleAvatar(radius: 3, backgroundColor: textColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? textColor
                      : textColor.withValues(alpha: 0.6),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
