
import 'package:flutter/material.dart';

import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import 'AddPharmacy_Controller.dart';
class PharmacyNameSection extends StatelessWidget {
  const PharmacyNameSection({super.key,required this.addPharmacyController});

  final AddPharmacyController addPharmacyController;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name (English)',
            style: TextStyle(
              fontSize: 12,
              color: colors.textSecondary,
              fontWeight: FontWeight.w500,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: size.height * 0.008),
          TextFormField(
            controller:
            addPharmacyController.nameEnController,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.translate,
                size: 20,
                color: AppColors.primaryColor,
              ),
              suffixIcon: Icon(
                Icons.check_circle,
                color: AppColors.primaryColor,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFCFD8DC),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            validator: (value) => value!.isEmpty
                ? 'This field is required'
                : null,
          ),
          const SizedBox(height: 16),

          Text(
            'Name (Arabic)',
            style: TextStyle(
              fontSize: 12,
              color: colors.textSecondary,
              fontWeight: FontWeight.w500,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller:
            addPharmacyController.nameArController,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              hintText: 'ادخل اسم الصيدلية بالعربية',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              fillColor: colors.backgroundMain,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) =>
            value!.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          const SizedBox(height: 4),
          Text(
            'Arabic characters only',
            style: TextStyle(
              fontSize: 12,
              color: colors.textSecondary,
              fontWeight: FontWeight.w500,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
