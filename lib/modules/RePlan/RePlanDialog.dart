import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';

import '../../Widgets/AppSnackBar.dart';
import '../../app_theme/theme_extension.dart';

class RePlanDialog extends StatefulWidget {
  final Function(String reason, String reasonDetails) onSubmit;

  const RePlanDialog({super.key, required this.onSubmit});

  @override
  State<RePlanDialog> createState() => _RePlanDialogState();
}

class _RePlanDialogState extends State<RePlanDialog> {
  String? selectedReason;
  final TextEditingController otherDetailsController = TextEditingController();

  final List<Map<String, String>> reasons = [
    {"label": "traffic_jam".tr, "value": "traffic_jam"},
    {"label": "road_closure".tr, "value": "road_closure"},
    {"label": "accident_ahead".tr, "value": "accident_ahead"},
    {"label": "pharmacy_closed".tr, "value": "pharmacy_closed"},
    {"label": "schedule_change".tr, "value": "schedule_change"},
    {"label": "other".tr, "value": "other"},
  ];

  @override
  void dispose() {
    otherDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: colors.component,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "WHY_ARE_YOU_RE-PLANNING".tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colors.textSecondary,
                fontFamily: 'Cairo',
              ),
            ),
             SizedBox(height: size.height * 0.02),
            Wrap(
              spacing: 4,
              runSpacing: 5,
              children: reasons.map((item) {
                final isSelected = selectedReason == item["value"];
                return ChoiceChip(
                  label: Text(
                    item["label"]!,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: isSelected ? Colors.white : colors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: colors.textPrimary,
                  backgroundColor: colors.backgroundMain,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? colors.textPrimary : colors.textSecondary.withValues(alpha: 0.3),
                    ),
                  ),
                  showCheckmark: false,
                  onSelected: (selected) {
                    setState(() {
                      selectedReason = selected ? item["value"] : null;
                    });
                  },
                );
              }).toList(),
            ),

            /// ظهور الـ TextField فقط إذا اختار Other
            if (selectedReason == "other") ...[
               SizedBox(height: size.height * 0.02),
              TextField(
                controller: otherDetailsController,
                //maxLines: 2,
                decoration: InputDecoration(
                  hintText: "Enter_the_reason_for_re-planning...".tr,
                  hintStyle: TextStyle(fontSize: 12, fontFamily: 'Cairo',color: colors.textSecondary),
                  filled: true,
                  fillColor: colors.backgroundMain,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
            SizedBox(height: size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    "Cancel".tr,
                    style: const TextStyle(color: Colors.grey, fontFamily: 'Cairo'),
                  ),
                ),
                 SizedBox(width: size.width * 0.01),
                ElevatedButton(
                  onPressed: () {
                    if (selectedReason == null) {
                      AppSnackBar.error("Please select a reason");
                      return;
                    }
                    if (selectedReason == "other" && otherDetailsController.text.trim().isEmpty) {
                      AppSnackBar.error("Please enter reason details");
                      return;
                    }
                    final reasonValue = selectedReason!;
                    final reasonDetails = selectedReason == "other"
                        ? otherDetailsController.text.trim()
                        : reasons.firstWhere((r) => r["value"] == selectedReason)["label"]!;
                    Get.back();
                    widget.onSubmit(reasonValue, reasonDetails);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Submit".tr,
                    style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}