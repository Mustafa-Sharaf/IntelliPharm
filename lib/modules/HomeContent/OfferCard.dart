import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import 'HomeContent_Model.dart';

class OfferCard extends StatelessWidget {
  final ActiveOfferModel offer;

  const OfferCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final bool isPercentage = offer.type == 'percentage';
    String badgeText;
    if (isPercentage) {
      badgeText =
          "${double.tryParse(offer.percentage ?? '0')?.toStringAsFixed(0)}% ${"OFF".tr}";
    } else {
      final int qty = offer.quantity ?? 1;
      badgeText = Get.locale?.languageCode == 'ar'
          ? "${"GIFT".tr} x$qty"
          : "${qty}x ${"GIFT".tr}";
    }
    final String title = isPercentage
        ? "DiscountOffer".tr
        : (offer.medicine?.commercialName ?? "FreeGift".tr);
    final String subtitle = "${"MinOrder".tr}: ${offer.requiredAmount}";

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Container(
                  height: size.height * 0.15,
                  width: double.infinity,
                  color: AppColors.primaryColor.withValues(alpha: 0.08),
                  child: offer.image != null && offer.image!.isNotEmpty
                      ? Image.network(
                          offer.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholderIcon(),
                        )
                      : _buildPlaceholderIcon(),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colors.textDefault,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.textSecondary,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Center(
      child: Icon(
        offer.type == 'percentage'
            ? Icons.local_offer_rounded
            : Icons.card_giftcard_rounded,
        size: 38,
        color: AppColors.primaryColor.withValues(alpha: 0.4),
      ),
    );
  }
}
