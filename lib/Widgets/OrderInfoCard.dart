import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_theme/AppColors.dart';
import '../app_theme/theme_extension.dart';

class OrderInfoCard extends StatelessWidget {
  final dynamic visit;
  final String regionName;
  const OrderInfoCard({
    super.key,
    required this.visit,
    required this.regionName,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ORDER_REFERENCE".tr,
                style: TextStyle(
                  fontSize: 11,
                  color: colors.textSecondary,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F6F4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  //"IN TRANSIT",
                  visit.status.toUpperCase(),
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.007),
          Text(//"#ORD-${visit.orderId}",
            "ORDER_REFERENCE_VALUE".trParams({
              'orderId': visit.orderId.toString(),
            }),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors.textDefault,
              fontFamily: 'Cairo',
            ),
          ),
          Divider(height: size.height * 0.03),
          Row(
            children: [
              Icon(
                Icons.local_pharmacy_outlined,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: size.width * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visit.pharmacyName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: colors.textDefault,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                     // "Regin: $regionName",
                      "REGION_NAME".trParams({
                        'region': regionName,
                      }),
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
