import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import 'MedicineDetails_Controller.dart';
import 'MedicineDetails_Model.dart';

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
              // 1. الصورة الرئيسية للدواء
              Container(
                width: double.infinity,
                height: size.height * 0.22,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                  image: med.images.isNotEmpty
                      ? DecorationImage(
                    image: NetworkImage(med.images.first),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: med.images.isEmpty
                    ? Center(
                  child: Icon(Icons.medication, size: 60, color: colors.textSecondary),
                )
                    : null,
              ),
              SizedBox(height: size.height * 0.02),

              // 2. الاسم والتصنيف
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
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.15),
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

              // 3. كروت المعلومات الأساسية (Grid 2x2)
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildDetailTile(
                    title: "PRICE_PER_UNIT".tr,
                    value: "${formatter.format(med.price)} ${'SP'.tr}",
                    colors: colors,
                  ),
                  _buildDetailTile(
                    title: "STOCK_AVAILABLE".tr,
                    value: "${med.availableQuantity} ${'units'.tr}",
                    colors: colors,
                  ),
                  _buildDetailTile(
                    title: "MANUFACTURER".tr,
                    value: med.laboratory?.name ?? "-",
                    colors: colors,
                  ),
                  _buildDetailTile(
                    title: "BARCODE".tr,
                    value: med.barcode.isNotEmpty ? med.barcode : "-",
                    colors: colors,
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.015),

              // 4. كرت العرض/الهدايا (Gift Promo Card)
              if (med.gift != null && med.gift!.giftQuantity > 0) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xff0e3866),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_offer, color: Colors.white, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "GIFT_PROMO".trParams({
                            'required_qty': med.gift!.requiredQuantity.toString(),
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
                ),
                SizedBox(height: size.height * 0.02),
              ],

              // 5. قسم البدائل (Alternatives Section)
              if (med.alternatives.isNotEmpty) ...[
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

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: med.alternatives.length,
                  itemBuilder: (context, index) {
                    final alt = med.alternatives[index];
                    return _buildAlternativeTile(
                      alt: alt,
                      colors: colors,
                      currentLang: currentLang,
                      formatter: formatter,
                    );
                  },
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDetailTile({
    required String title,
    required String value,
    required ThemeColors colors,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              color: colors.textSecondary,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlternativeTile({
    required AlternativeMedicine alt,
    required ThemeColors colors,
    required String currentLang,
    required NumberFormat formatter,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.textSecondary.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // صورة البديل
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
              image: alt.images.isNotEmpty
                  ? DecorationImage(
                image: NetworkImage(alt.images.first),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: alt.images.isEmpty
                ? const Icon(Icons.medication_liquid, color: AppColors.primaryColor)
                : null,
          ),
          const SizedBox(width: 12),

          // الاسم التجاري والملاحظة
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alt.commercialName.getName(currentLang),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                    fontFamily: 'Cairo',
                  ),
                ),
                if (alt.note.isNotEmpty)
                  Text(
                    "${'Note'.tr}: ${alt.note}",
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textSecondary,
                      fontFamily: 'Cairo',
                    ),
                  ),
              ],
            ),
          ),

          // السعر وحالة الدواء
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${formatter.format(alt.price)} ${'SP'.tr}",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: alt.isImported ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  alt.isImported ? "Imported".tr : "Local".tr,
                  style: TextStyle(
                    fontSize: 10,
                    color: alt.isImported ? Colors.orange.shade800 : Colors.green.shade800,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}