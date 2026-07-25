/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/OrderInfoCard.dart';
import '../../app_theme/theme_extension.dart';
import '../ActiveDeliveryRoute/ActiveDeliveryRoute_Model.dart';
import 'ConfirmDelivery_Controller.dart';

class ConfirmDeliveryScreen extends StatelessWidget {
  final DeliveryVisit visit;
  final String regionName;

  const ConfirmDeliveryScreen({
    super.key,
    required this.visit,
    required this.regionName,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConfirmDeliveryController(visit: visit));
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        backgroundColor: colors.backgroundMain,
        foregroundColor: colors.textPrimary,
        centerTitle: true,
        title: Text(
          "ConfirmDelivery".tr,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Cairo',
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(size.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderInfoCard(visit: visit, regionName: regionName),
                SizedBox(height: size.height * 0.03),
                Text(
                  "PROOF_OF_DELIVERY".tr,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Obx(
                  () => GestureDetector(
                    onTap: controller.pickImage,
                    child: Container(
                      height: size.height * 0.2,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colors.component,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colors.textSecondary.withValues(alpha: 0.2),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: controller.selectedImage.value != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                controller.selectedImage.value!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 40,
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  "Take_Photo".tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colors.textDefault,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                Text(
                                  "Tap_to_capture_parcel".tr,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colors.textSecondary,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  "RECEIVER_NAME".tr,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                    fontFamily: 'Cairo',
                    height: 2,
                  ),
                ),
                _buildTextField(
                  controller.receiverNameController,
                  "Recipient's_name".tr,
                  colors,
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  "PAYMENT_AMOUNT_(OPTIONAL)".tr,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                    fontFamily: 'Cairo',
                    height: 2,
                  ),
                ),

                _buildTextField(
                  controller.paymentAmountController,
                  "0.00".tr,
                  colors,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  "CHECK_NOTES_(OPTIONAL)".tr,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                    fontFamily: 'Cairo',
                    height: 2,
                  ),
                ),

                _buildTextField(
                  controller.notesController,
                  "Add_any_delivery_satisfaction_notes".tr,
                  colors,
                  maxLines: 2,
                ),
                SizedBox(height: size.height * 0.1),
              ],
            ),
          ),

          Positioned(
            bottom: size.height * 0.03,
            left: size.width * 0.02,
            right: size.width * 0.02,
            child: SizedBox(
              width: double.infinity,
              height: size.height * 0.06,
              child: Obx(
                () => ElevatedButton.icon(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : //controller.submitDelivery,
                      () async {
                    // استدعاء الدالة مباشرة، والـ Controller سيقوم بالرجوع فوراً عند النجاح
                    await controller.submitDelivery();
                  },
                  icon: controller.isSubmitting.value
                      ? CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : Icon(Icons.check_circle_outline, color: Colors.white),
                  label: Text(
                    controller.isSubmitting.value
                        ? "Processing...".tr
                        : "ConfirmDelivery".tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    ThemeColors colors, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(color: colors.textDefault),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: colors.textSecondary.withValues(alpha: 0.5),
            fontSize: 13,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/OrderInfoCard.dart';
import '../../app_theme/theme_extension.dart';
import '../ActiveDeliveryRoute/ActiveDeliveryRoute_Model.dart';
import 'ConfirmDelivery_Controller.dart';

class ConfirmDeliveryScreen extends StatelessWidget {
  const ConfirmDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🟢 جلب البيانات الممررة في Get.arguments
    final Map<String, dynamic> args = Get.arguments ?? {};
    final DeliveryVisit visit = args['visit'];
    final String regionName = args['regionName'] ?? '';

    // 🟢 جلب الكنترولر المحقون عبر الـ Binding
    final controller = Get.find<ConfirmDeliveryController>();
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        backgroundColor: colors.backgroundMain,
        foregroundColor: colors.textPrimary,
        centerTitle: true,
        title: Text(
          "ConfirmDelivery".tr,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Cairo',
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(size.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderInfoCard(visit: visit, regionName: regionName),
                SizedBox(height: size.height * 0.03),
                Text(
                  "PROOF_OF_DELIVERY".tr,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Obx(
                      () => GestureDetector(
                    onTap: controller.pickImage,
                    child: Container(
                      height: size.height * 0.2,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colors.component,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colors.textSecondary.withValues(alpha: 0.2),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: controller.selectedImage.value != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          controller.selectedImage.value!,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_alt_outlined,
                            size: 40,
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(height: size.height * 0.01),
                          Text(
                            "Take_Photo".tr,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colors.textDefault,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          Text(
                            "Tap_to_capture_parcel".tr,
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.textSecondary,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  "RECEIVER_NAME".tr,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                    fontFamily: 'Cairo',
                    height: 2,
                  ),
                ),
                _buildTextField(
                  controller.receiverNameController,
                  "Recipient's_name".tr,
                  colors,
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  "PAYMENT_AMOUNT_(OPTIONAL)".tr,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                    fontFamily: 'Cairo',
                    height: 2,
                  ),
                ),
                _buildTextField(
                  controller.paymentAmountController,
                  "0.00".tr,
                  colors,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  "CHECK_NOTES_(OPTIONAL)".tr,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                    fontFamily: 'Cairo',
                    height: 2,
                  ),
                ),
                _buildTextField(
                  controller.notesController,
                  "Add_any_delivery_satisfaction_notes".tr,
                  colors,
                  maxLines: 2,
                ),
                SizedBox(height: size.height * 0.1),
              ],
            ),
          ),
          Positioned(
            bottom: size.height * 0.03,
            left: size.width * 0.02,
            right: size.width * 0.02,
            child: SizedBox(
              width: double.infinity,
              height: size.height * 0.06,
              child: Obx(
                    () => ElevatedButton.icon(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : () async => await controller.submitDelivery(),
                  icon: controller.isSubmitting.value
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                      : const Icon(Icons.check_circle_outline, color: Colors.white),
                  label: Text(
                    controller.isSubmitting.value
                        ? "Processing...".tr
                        : "ConfirmDelivery".tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String hint,
      ThemeColors colors, {
        TextInputType keyboardType = TextInputType.text,
        int maxLines = 1,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(color: colors.textDefault),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: colors.textSecondary.withValues(alpha: 0.5),
            fontSize: 13,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}