import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/AlternativeTileWidget.dart';
import '../../Widgets/DetailTileWidget.dart';
import '../../app_theme/theme_extension.dart';
import 'MedicineDetails_Controller.dart';

class MedicineDetailsScreen extends StatelessWidget {
  const MedicineDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MedicineDetailsController());
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final formatter = NumberFormat('#,##0.00');
    final String currentLang = Get.locale?.languageCode ?? 'ar';

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        backgroundColor: colors.backgroundMain,
        elevation: 0,
        foregroundColor: colors.textPrimary,
        centerTitle: true,
        title: Text(
          "Medicine_Details".tr,
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
        final med = controller.medicineData.value;
        if (med == null) {
          return Center(
            child: Text(
              "Failed_to_load_details".tr,
              style: TextStyle(color: colors.textPrimary, fontFamily: 'Cairo'),
            ),
          );
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(size.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: size.height * 0.2,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: med.images.isNotEmpty
                      ? Image.network(
                          med.images.first,
                          fit: BoxFit.fill,
                          errorBuilder: (_, __, ___) => Image.asset(
                            "assets/images/medicine_Image.png",
                            fit: BoxFit.fill,
                          ),
                        )
                      : Image.asset(
                          "assets/images/medicine_Image.png",
                          fit: BoxFit.fill,
                        ),
                ),
              ),
              SizedBox(height: size.height * 0.02),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          med.commercialName.getName(currentLang),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        if (med.scientificName.isNotEmpty)
                          Text(
                            med.scientificName,
                            style: TextStyle(
                              fontSize: 13,
                              color: colors.textSecondary,
                              fontFamily: 'Cairo',
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (med.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        med.category!.name,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: size.height * 0.02),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  DetailTileWidget(
                    title: "PRICE_PER_UNIT".tr,
                    value: "${formatter.format(med.price)} ${'SP'.tr}",
                  ),
                  DetailTileWidget(
                    title: "STOCK_AVAILABLE".tr,
                    value: "${med.availableQuantity} ${'units'.tr}",
                  ),
                  DetailTileWidget(
                    title: "MANUFACTURER".tr,
                    value: med.laboratory?.name ?? "-",
                  ),
                  DetailTileWidget(
                    title: "BARCODE".tr,
                    value: med.barcode.isNotEmpty ? med.barcode : "-",
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.015),

              if (med.gift != null && med.gift!.giftQuantity > 0)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xff0e3866),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.card_giftcard_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      SizedBox(width: size.width * 0.02),
                      Expanded(
                        child: Text(
                          "GIFT_PROMO".trParams({
                            'required_qty': med.gift!.requiredQuantity
                                .toString(),
                            'gift_qty': med.gift!.giftQuantity.toString(),
                          }),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.component,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: colors.textSecondary.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.card_giftcard_outlined,
                        color: colors.textSecondary,
                        size: 22,
                      ),
                      SizedBox(width: size.width * 0.02),
                      Text(
                        "No_Offers_Available".tr,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontFamily: 'Cairo',
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: size.height * 0.02),
              Text(
                "Alternatives".tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
              SizedBox(height: size.height * 0.01),
              if (med.alternatives.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: med.alternatives.length,
                  itemBuilder: (context, index) {
                    return AlternativeTileWidget(
                      alt: med.alternatives[index],
                      formatter: formatter,
                    );
                  },
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: colors.component,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: colors.textSecondary.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.medication_liquid_sharp,
                        color: colors.textSecondary.withValues(alpha: 0.5),
                        size: 36,
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        "No_Alternatives_Available".tr,
                        style: TextStyle(
                          fontSize: 13,
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
      }),
    );
  }
}
