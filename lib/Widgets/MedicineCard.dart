import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../app_theme/theme_extension.dart';
import 'package:get/get.dart';

import '../modules/Alternatives/Alternatives_Screen.dart';

class MedicineCard extends StatelessWidget {
  final int  medicineId;
  final String commercialName;
  final String scientificName;
  final String price;
  final String stockQuantity;
  final String status;
  final String discount;
  final String image;
  final TextEditingController controller;
  final VoidCallback onAdd;
  final bool isImported;
  final bool showAlternativesButton;

  const MedicineCard({
    super.key,
    required this.medicineId,
    required this.commercialName,
    required this.scientificName,
    required this.price,
    required this.stockQuantity,
    required this.status,
    required this.discount,
    required this.image,
    required this.controller,
    required this.onAdd,
    required this.isImported,
    this.showAlternativesButton = true,
  });

  Color getStatusColor() {
    if (isImported) {
      return Colors.red;
    }
    return Colors.green;
  }

  bool get hasDiscount => discount.trim().isNotEmpty && discount != "0";

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: size.height * 0.006),
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.022,
            horizontal: size.height * 0.018,
          ),
          decoration: BoxDecoration(
            color: colors.component,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * 0.15,
                    height: size.width * 0.15,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: image.startsWith('http')
                          ? Image.network(
                              image,
                              fit: BoxFit.fill,
                              errorBuilder: (_, __, ___) => Image.asset(
                                "assets/images/medicine_Image.png",
                                fit: BoxFit.fill,
                              ),
                            )
                          : Image.asset(
                              image,
                              fit: BoxFit.fill,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.medication, size: 30),
                            ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.02),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.03,
                            vertical: size.width * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: getStatusColor().withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: getStatusColor(),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                commercialName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                            Text(
                              price,
                              style: TextStyle(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                scientificName,
                                style: TextStyle(
                                  color: colors.textSecondary,
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "QTY_STOCK".trParams({
                                'stock': stockQuantity.toString(),
                              }),
                              style: TextStyle(
                                color: colors.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: size.height * 0.01),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width * 0.15,
                    height: size.height * 0.04,
                    decoration: BoxDecoration(
                      color: colors.backgroundMain,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "0",
                      ),
                    ),
                  ),

                  //SizedBox(width: size.width * 0.005),
                  SizedBox(
                    width: size.width * 0.33,
                    height: size.height * 0.04,
                    child: ElevatedButton(
                      onPressed: onAdd,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Add_to_cart".tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  if (showAlternativesButton)
                  SizedBox(
                    width: size.width * 0.33,
                    height: size.height * 0.04,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(
                          () => AlternativesScreen(medicineId: medicineId),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Alternatives".tr,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'Cairo',
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        if (hasDiscount)
          PositionedDirectional(
            top: size.height * 0.006,
            end: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: size.height * 0.01,
                vertical: size.height * 0.005,
              ),
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(16),
                  bottomStart: Radius.circular(12),
                ),
              ),
              child: Text(
                discount,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
