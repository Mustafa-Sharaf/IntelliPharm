import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/RegionSelector/RegionSelector_Model.dart';
import '../../helper/Time/dart/timeHelper.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart'; // تأكد من المسار الصحيح
import '../../services/ServiceApi/PharmacyService.dart';
import 'AddPharmacy_Model.dart'; // تأكد من مسار الموديل


class AddPharmacyController extends GetxController {
  var openTime = Rx<TimeOfDay?>(null);
  var closeTime = Rx<TimeOfDay?>(null);
  final formKey = GlobalKey<FormState>();
  var selectedRegion = Rxn<RegionModel>();

  final nameEnController = TextEditingController();
  final nameArController = TextEditingController();
  final pharmacistNameController = TextEditingController();
  final phoneController = TextEditingController();
  final altPhoneController = TextEditingController();

  var isActive = true.obs;
  var countryCode = "+963".obs;

  // 1. إضافة متغير حالة التحميل لمنع التكرار وعرض مؤشر للمستخدم
  var isLoading = false.obs;

  /// دالة مساعدة لتحويل TimeOfDay إلى نص HH:mm متوافق مع الـ API
  String _formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return "";
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return "$hours:$minutes";
  }

  /// 2. دالة حفظ الصيدلية وإرسالها للباك إند
  Future<void> savePharmacy() async {
    // أ- فحص الـ Form Validation للحقول النصية
    if (!formKey.currentState!.validate()) return;

    // ب- فحص هل تم اختيار المنطقة
    if (selectedRegion.value == null) {
      Get.snackbar("تنبيه", "الرجاء اختيار المنطقة أولاً", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // ج- فحص هل تم اختيار أوقات الدوام
    if (openTime.value == null || closeTime.value == null) {
      Get.snackbar("تنبيه", "الرجاء تحديد أوقات الفتح والإغلاق", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // د- جلب إحداثيات الخريطة من الـ MapHelperController
    final mapController = Get.find<MapHelperController>(tag: "addPharmacy");
    if (mapController.latitude.value == 0.0 || mapController.longitude.value == 0.0) {
      Get.snackbar("تنبيه", "الرجاء تحديد موقع الصيدلية على الخريطة", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;

      // هـ- بناء الـ Request Model وتجهيز البيانات بالكامل
      CreatePharmacyModel requestData = CreatePharmacyModel(
        nameEn: nameEnController.text.trim(),
        nameAr: nameArController.text.trim(),
        regionId: selectedRegion.value!.id, // نأخذ الـ id من موديل المنطقة المحدد
        latitude: mapController.latitude.value,
        longitude: mapController.longitude.value,
        openingTime: _formatTimeOfDay(openTime.value),
        closingTime: _formatTimeOfDay(closeTime.value),
        isActive: isActive.value,
        pharmacistName: pharmacistNameController.text.trim(),
        pharmacistPhone: phoneController.text.trim(),
        // نرسل الهاتف البديل null إذا كان فارغاً
        pharmacistAltPhone: altPhoneController.text.trim().isEmpty ? null : altPhoneController.text.trim(),
      );

      // و- إرسال البيانات إلى السيرفس
      final result = await PharmacyService.createPharmacy(requestData);

      // ز- نجاح العملية
      Get.snackbar("نجاح", "تمت إضافة الصيدلية بنجاح",
          backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);

      // يمكنك هنا عمل Back أو تفريغ الحقول حسب منطق تطبيقك
      Get.back();

    } catch (e) {
      // ح- معالجة الأخطاء
      Get.snackbar("خطأ", "فشلت عملية الحفظ: $e",
          backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Time selection
  Future<void> pickTime({
    required BuildContext context,
    required Rx<TimeOfDay?> targetTime,
    required Color backgroundColor,
  }) async {
    final picked = await TimeHelper.pickTime(
      context: context,
      initialTime: targetTime.value,
      backgroundColor: backgroundColor,
    );

    if (picked != null) {
      targetTime.value = picked;
    }
  }

  @override
  void onClose() {
    nameEnController.dispose();
    nameArController.dispose();
    pharmacistNameController.dispose();
    phoneController.dispose();
    altPhoneController.dispose();
    super.onClose();
  }
}