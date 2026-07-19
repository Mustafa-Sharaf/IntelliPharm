import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../ActiveDeliveryRoute/ActiveDeliveryRoute_Model.dart';
import 'ConfirmDelivery_Controller.dart';

class ConfirmDeliveryScreen extends StatelessWidget {
  final DeliveryVisit visit;

  const ConfirmDeliveryScreen({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConfirmDeliveryController(visit: visit));
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colors.textDefault),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Confirm Delivery".tr,
          style: TextStyle(
            color: colors.textDefault,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // كرت تفاصيل الطلب العلوي
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: colors.component,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ORDER REFERENCE",
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.textSecondary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F6F4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "IN TRANSIT",
                              style: TextStyle(
                                color: Color(0xFF107064),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "#ORD-${visit.orderId}", // تم التعديل لعرض رقم الأوردر الصحيح من الـ API
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colors.textDefault,
                        ),
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          Icon(Icons.local_pharmacy_outlined, color: AppColors.primaryColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  visit.pharmacyName, // تم التعديل هنا ليتوافق مع الموديل الجديد المباشر
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: colors.textDefault,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                Text(
                                  "Status: ${visit.status}", // تم التعديل لعرض الحالة القادمة من السيرفر
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
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // قسم إثبات التوصيل والتقاط الصورة
                Text(
                  "PROOF OF DELIVERY",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() => GestureDetector(
                  onTap: controller.pickImage,
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colors.component,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colors.textSecondary.withOpacity(0.2),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: controller.selectedImage.value != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(controller.selectedImage.value!, fit: BoxFit.cover),
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined, size: 40, color: AppColors.primaryColor),
                        const SizedBox(height: 8),
                        Text(
                          "Take Photo",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colors.textDefault,
                          ),
                        ),
                        Text(
                          "Tap to capture parcel",
                          style: TextStyle(fontSize: 11, color: colors.textSecondary),
                        )
                      ],
                    ),
                  ),
                )),
                const SizedBox(height: 20),

                _buildSectionHeader("RECEIVER NAME", colors),
                _buildTextField(controller.receiverNameController, "Full legal name", colors),
                const SizedBox(height: 20),

                _buildSectionHeader("PAYMENT AMOUNT (OPTIONAL)", colors),
                _buildTextField(controller.paymentAmountController, "0.00", colors, keyboardType: TextInputType.number),
                const SizedBox(height: 20),

                _buildSectionHeader("CHECK NOTES (OPTIONAL)", colors),
                _buildTextField(controller.notesController, "Add any delivery satisfaction notes", colors, maxLines: 2),
                const SizedBox(height: 100),
              ],
            ),
          ),

          // الزر العائم للتأكيد
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: Obx(() => ElevatedButton.icon(
                onPressed: controller.isSubmitting.value ? null : controller.submitDelivery,
                icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                label: Text(
                  controller.isSubmitting.value ? "Processing...".tr : "Confirm Delivery".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: colors.textSecondary,
          letterSpacing: 1.1,
        ),
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
          hintStyle: TextStyle(color: colors.textSecondary.withOpacity(0.5), fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }
}