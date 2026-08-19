import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_theme/AppColors.dart';
import '../../../app_theme/theme_extension.dart';
import '../modules/ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Controller.dart';

class PharmacyInfoCard extends StatelessWidget {
  final String pharmacyName;
  final String regionName;
  final String openTime;
  final String closeTime;
  final String pharmacistName;
  final bool isOpen;
  final VoidCallback? onContactTap;
  final VoidCallback? onViewNotesTap;
  final VoidCallback? onDirectionsTap;
  final VoidCallback? onCartTap;

  const PharmacyInfoCard({
    super.key,
    required this.pharmacyName,
    required this.regionName,
    required this.openTime,
    required this.closeTime,
    required this.pharmacistName,
    this.isOpen = true,
    this.onContactTap,
    this.onViewNotesTap,
    this.onDirectionsTap,
    this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: size.width * 0.008,
        horizontal: size.width * 0.01,
      ),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 5, color: AppColors.primaryColor),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.all(size.width * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              pharmacyName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.02,
                              vertical: size.width * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: isOpen
                                  ? const Color(0xFFE8F5E9)
                                  : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isOpen ? 'Open'.tr : 'Closed'.tr,
                              style: TextStyle(
                                color: isOpen ? Colors.green : Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.width * 0.02),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoRow(
                              Icons.location_on_outlined,
                              regionName,
                              colors.textSecondary,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: size.width * 0.009,
                              right: size.width * 0.009,
                            ),
                            child: GestureDetector(
                              onTap: onContactTap,
                              child:       Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child:  Icon(
                                  Icons.phone,
                                  color: AppColors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.width * 0.006),
                      _buildInfoRow(
                        Icons.access_time,
                        "$openTime – $closeTime",
                        colors.textSecondary,
                      ),
                      SizedBox(height: size.width * 0.02),
                      _buildInfoRow(
                        Icons.person_outline_rounded,
                        "PHARMACIST_NAME".trParams({
                          'name': pharmacistName,
                        }),
                        colors.textSecondary,
                      ),
                      SizedBox(height: size.width * 0.04),
                      Divider(color: Colors.grey.shade200, height: 1),
                      SizedBox(height: size.width * 0.04),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: onViewNotesTap,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 1.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                              ),
                              child:  Text(
                                'ViewNotes'.tr,
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: size.width * 0.02),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: onDirectionsTap,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color:Colors.green,
                                  width: 1.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                              ),
                              child: Text(
                                'Directions'.tr,
                                style: TextStyle(
                                  color: Colors.green,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: size.width * 0.02),
                          Container(
                            height: size.width * 0.1,
                            width: size.width * 0.11,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: onCartTap,
                              icon: const Icon(
                                Icons.add_shopping_cart_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color textColor) {
    return Row(
      children: [
        Icon(icon, size: 16, color: textColor),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: textColor,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
