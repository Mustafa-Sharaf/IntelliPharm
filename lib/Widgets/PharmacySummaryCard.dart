import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_theme/theme_extension.dart';
import '../helper/ContactLauncher/ContactLauncher.dart';
import '../helper/DateHelper.dart';

class PharmacySummaryCard extends StatelessWidget {
  final dynamic pharmacy;
  final dynamic controller;
  final bool showScheduledVisit;
  final bool showPharmacistInfo;
  final bool showContactIcon;

  const PharmacySummaryCard({
    super.key,
    required this.pharmacy,
    required this.controller,
    this.showScheduledVisit = false,
    this.showPharmacistInfo = true,
    this.showContactIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    String holidayText = "";
    bool hasHolidays = false;

    if (pharmacy.holidays != null && pharmacy.holidays is List && pharmacy.holidays.isNotEmpty) {

      holidayText = (pharmacy.holidays as List).join(' , ');
      hasHolidays = true;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(size.width * 0.05),
          decoration: BoxDecoration(
            color: colors.component,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Get.locale?.languageCode == 'ar'
                              ? pharmacy.nameAr
                              : pharmacy.nameEn,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            color: colors.textPrimary,
                          ),
                        ),
                        SizedBox(height: size.height * 0.005),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            pharmacy.region.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: pharmacy.isOpen ? const Color(0xFFE0F2F1) : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 3,
                                backgroundColor: pharmacy.isOpen ? const Color(0xFF00796B) : Colors.red,
                              ),
                              SizedBox(width: size.width * 0.008),
                              Text(
                                pharmacy.isOpen ? "OPEN_NOW".tr : "CLOSED",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: pharmacy.isOpen ? const Color(0xFF00796B) : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (hasHolidays) ...[
                          SizedBox(height: size.height * 0.005),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                             //"Holiday: $holidayText",
                              "HOLIDAY_LABEL".trParams({
                                'text': holidayText,
                              }),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on_outlined, size: 18, color: colors.textSecondary),
                  SizedBox(width: size.width * 0.008),
                  Expanded(
                    child: Obx(() => Text(
                      controller.actualAddress.value,
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.textSecondary,
                        height: 1.5,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ],
              ),

              if (showPharmacistInfo) ...[
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 18, color: colors.textSecondary),
                        SizedBox(width: size.width * 0.01),
                        Text(
                          pharmacy.pharmacistName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colors.textPrimary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                    if (showContactIcon)
                      GestureDetector(
                        onTap: () => ContactLauncher().showContactOptions(
                          context,
                          pharmacy.pharmacistPhone,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(size.width * 0.025),
                          decoration: const BoxDecoration(
                            color: Color(0xFF00BFA5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.phone, color: Colors.white, size: 22),
                        ),
                      ),
                  ],
                ),
              ],

              if (showScheduledVisit) ...[
                const SizedBox(height: 10),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF0F2547)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SCHEDULED_VISIT".tr,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: colors.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            DateHelper.formatScheduledVisit(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}