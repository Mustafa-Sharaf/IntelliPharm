import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../AppSnackBar.dart';

class ChangeStatusDialog extends StatefulWidget {
  final Function(String status, String cause, String notes) onSubmit;
  final bool isLoading;

  const ChangeStatusDialog({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<ChangeStatusDialog> createState() => _ChangeStatusDialogState();
}

class _ChangeStatusDialogState extends State<ChangeStatusDialog> {
  String selectedStatus = 'blocked';
  String? selectedCause;
  final TextEditingController notesController = TextEditingController();

  final List<Map<String, dynamic>> statuses = [
    {
      'key': 'blocked',
      'label': 'status_blocked',
      'color': const Color(0xFFE57373),
    },
    {
      'key': 'failed',
      'label': 'status_failed',
      'color': const Color(0xFFFFB74D),
    },
    {
      'key': 'skipped',
      'label': 'status_skipped',
      'color': const Color(0xFF64B5F6),
    },
  ];

  final List<Map<String, String>> allowedCauses = [
    {'key': 'closure', 'label': 'pharmacy_closure'},
    {'key': 'traffic', 'label': 'traffic_jam'},
    {'key': 'holiday', 'label': 'official_holiday'},
    {'key': 'weather', 'label': 'weather_conditions'},
    {'key': 'customer_delay', 'label': 'pharmacist_delay'},
  ];
  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: colors.component,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// العنوان
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Change_visit_status".tr,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 20, color: colors.textDefault),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),

            /// Chip buttons for the case
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: statuses.map((item) {
                  final isSelected = selectedStatus == item['key'];
                  final Color itemColor = item['color'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedStatus = item['key'];
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? itemColor.withValues(alpha: 0.2)
                            : colors.backgroundMain,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? itemColor : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(radius: 4, backgroundColor: itemColor),
                          SizedBox(width: size.width * 0.02),
                          Text(
                            item['label'].toString().tr,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? itemColor : Colors.grey[700],
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: size.height * 0.02),

            /// 1. Select the reason (Dropdown)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: colors.backgroundMain,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCause,
                  hint: Text(
                    "Choose_the_reason_for_non-completion...".tr,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  isExpanded: true,
                  items: allowedCauses.map((cause) {
                    return DropdownMenuItem<String>(
                      value: cause['key'],
                      child: Text(
                        cause['label']!.tr,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedCause = val;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),

            /// 2. Enter notes (TextField) + press send button
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: colors.backgroundMain,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: notesController,
                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
                      decoration: InputDecoration(
                        hintText: "Enter_additional_notes_(optional)...".tr,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: 'Cairo',
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.015),
                GestureDetector(
                  onTap: widget.isLoading
                      ? null
                      : () {
                          if (selectedCause == null) {
                            AppSnackBar.error(
                              "Please_select_the_reason_first.".tr,
                            );
                            return;
                          }
                          widget.onSubmit(
                            selectedStatus,
                            selectedCause!,
                            notesController.text.trim(),
                          );
                        },
                  child: Container(
                    height: size.height * 0.055,
                    width: size.height * 0.055,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: widget.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              FontAwesomeIcons.paperPlane,
                              color: Colors.white,
                              size: 16,
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
}
