import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/theme_extension.dart';
import 'AddPharmacy_Controller.dart';

class PharmacyContactSection extends StatelessWidget {
  const PharmacyContactSection({
    super.key,
    required this.addPharmacyController,
  });

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
            'Pharmacist Name (Optional)',
            style: TextStyle(
              fontSize: 12,
              color: colors.textSecondary,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: size.height * 0.005),
          TextFormField(
            controller: addPharmacyController.pharmacistNameController,
            decoration: InputDecoration(
              hintText: 'Enter pharmacist name',
              hintStyle: TextStyle(
                fontSize: 13,
                color: colors.textSecondary.withValues(alpha: 0.6),
                fontFamily: 'Cairo',
              ),
              prefixIcon: Icon(
                Icons.person_outline,
                size: 20,
                color: colors.textSecondary.withValues(alpha: 0.6),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: size.width * 0.02),
              fillColor: colors.backgroundMain,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.005),
          Row(
            children: [
              Text(
                'Phone Number',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textSecondary,
                  fontFamily: 'Cairo',
                ),
              ),
              const Text(' *', style: TextStyle(color: Colors.red)),
            ],
          ),
          SizedBox(height: size.height * 0.005),

          TextFormField(
            controller: addPharmacyController.phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is required';
              }
              if (!GetUtils.isNumericOnly(value)) {
                return 'Please enter numbers only';
              }
              if (value.length < 10) {
                return 'Phone number must be at least 10 digits';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter phone number',
              hintStyle: TextStyle(
                color: colors.textSecondary.withValues(alpha: 0.6),
                fontFamily: 'Cairo',
                fontSize: 13,
              ),
              errorStyle: const TextStyle(
                color: Colors.red,
                fontFamily: 'Cairo',
              ),
              prefixIcon: Builder(
                builder: (context) {
                  final FormFieldState? formFieldState = context
                      .findAncestorStateOfType<FormFieldState>();
                  final bool hasError = formFieldState?.hasError ?? false;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    margin: EdgeInsets.only(right: size.width * 0.02),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: hasError
                              ? Colors.red
                              : const Color(0xFFCFD8DC),
                        ),
                      ),
                    ),
                    child: Text(
                      addPharmacyController.countryCode.value,
                      style: TextStyle(
                        color: colors.textSecondary.withValues(alpha: 0.6),
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
              suffixIcon: Builder(
                builder: (context) {
                  final FormFieldState? formFieldState = context
                      .findAncestorStateOfType<FormFieldState>();
                  final bool hasError = formFieldState?.hasError ?? false;

                  return Icon(
                    hasError ? Icons.error : Icons.phone_android_outlined,
                    color: hasError
                        ? Colors.red
                        : colors.textSecondary.withValues(alpha: 0.4),
                  );
                },
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              fillColor: colors.backgroundMain,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 1.2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
          ),

          SizedBox(height: size.height * 0.01),

          Text(
            'Alternative Phone (Optional)',
            style: TextStyle(
              fontSize: 12,
              color: colors.textSecondary,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: size.height * 0.005),

          TextFormField(
            controller: addPharmacyController.altPhoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Enter phone number',
              hintStyle: TextStyle(
                color: colors.textSecondary.withValues(alpha: 0.6),
                fontFamily: 'Cairo',
                fontSize: 13,
              ),
              prefixIcon: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                margin: EdgeInsets.only(right: size.width * 0.02),
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: Color(0xFFCFD8DC))),
                ),
                child: Text(
                  addPharmacyController.countryCode.value,
                  style: TextStyle(
                    color: colors.textSecondary.withValues(alpha: 0.6),
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              suffixIcon: Icon(
                Icons.phone_android_outlined,
                color: colors.textSecondary.withValues(alpha: 0.4),
              ),
              fillColor: colors.backgroundMain,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
