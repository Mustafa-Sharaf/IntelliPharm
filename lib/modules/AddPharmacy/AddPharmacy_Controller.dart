import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/AppSnackBar.dart';
import '../../Widgets/RegionSelector/RegionSelector_Model.dart';
import '../../helper/Time/dart/timeHelper.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../../services/ServiceApi/PharmacyService.dart';
import 'AddPharmacy_Model.dart';

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
  var isLoading = false.obs;

  Future<void> createPharmacy() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedRegion.value == null) {
      AppSnackBar.error("الرجاء اختيار المنطقة أولاً");
      return;
    }

    if (openTime.value == null || closeTime.value == null) {
      AppSnackBar.error("الرجاء تحديد أوقات الفتح والإغلاق");
      return;
    }

    final mapController = Get.find<MapHelperController>(tag: "addPharmacy");
    if (mapController.latitude.value == 0.0 ||
        mapController.longitude.value == 0.0) {
      AppSnackBar.error("الرجاء تحديد موقع الصيدلية على الخريطة");
      return;
    }

    try {
      isLoading.value = true;

      CreatePharmacyModel requestData = CreatePharmacyModel(
        nameEn: nameEnController.text.trim(),
        nameAr: nameArController.text.trim(),
        regionId: selectedRegion.value!.id,
        latitude: mapController.latitude.value,
        longitude: mapController.longitude.value,
        openingTime: _formatTimeOfDay(openTime.value),
        closingTime: _formatTimeOfDay(closeTime.value),
        isActive: isActive.value,
        pharmacistName: pharmacistNameController.text.trim(),
        pharmacistPhone: phoneController.text.trim(),
        pharmacistAltPhone: altPhoneController.text.trim().isEmpty
            ? null
            : altPhoneController.text.trim(),
      );

      final response = await PharmacyService.createPharmacy(requestData);

      if (response["isSuccess"] == true) {
        AppSnackBar.success("تمت إضافة الصيدلية بنجاح");
      }
      clearFields();
    } catch (e) {
      AppSnackBar.error("فشلت عملية الحفظ");
      print("فشلت عملية الحفظ: $e");
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

  String _formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return "";
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return "$hours:$minutes";
  }

  void clearFields() {
    nameEnController.clear();
    nameArController.clear();
    pharmacistNameController.clear();
    phoneController.clear();
    altPhoneController.clear();
    openTime.value = null;
    closeTime.value = null;
    selectedRegion.value = null;
    isActive.value = true;

    try {
      final mapController = Get.find<MapHelperController>(tag: "addPharmacy");
      mapController.latitude.value = 0.0;
      mapController.longitude.value = 0.0;
    } catch (_) {}
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
