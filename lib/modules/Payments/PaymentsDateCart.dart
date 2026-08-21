

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app_theme/theme_extension.dart';
import 'RecordPayment_Controller.dart';
class PaymentsDateCart extends StatelessWidget {
  const PaymentsDateCart({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final controller = Get.find<RecordPaymentController>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'payment_date_label'.tr,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 11,
              fontFamily: 'Cairo',
            ),
          ),
          InkWell(
            onTap: () => controller.pickDate(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                        () => Text(
                      DateFormat(
                        'dd MMMM yyyy'.tr,
                      ).format(controller.selectedDate.value),
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: colors.textSecondary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          Divider(height:size.height*0.02),
          Text(
            'notes_optional_label'.tr,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 11,
              fontFamily: 'Cairo',
            ),
          ),
          TextField(
            controller: controller.notesController,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 13,
              fontFamily: 'Cairo',
            ),
            decoration: InputDecoration(
              hintText: 'add_payment_context_hint'.tr,
              hintStyle: TextStyle(
                color: colors.textSecondary.withValues(alpha: 0.5),
                fontSize: 12,
                fontFamily: 'Cairo',
              ),
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}

