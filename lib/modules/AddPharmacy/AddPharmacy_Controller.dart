import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/AppSnackBar.dart';
import '../../Widgets/RegionSelector/RegionSelector_Model.dart';
import '../../helper/Time/dart/timeHelper.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../../services/ServiceApi/PharmacyService.dart';
import 'AddPharmacy_Model.dart';

class AddPharmacyController extends GetxController {
  late MapHelperController mapController;
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


  final weekdays = [
    {"key": "sunday", "ar": "الأحد"},
    {"key": "monday", "ar": "الإثنين"},
    {"key": "tuesday", "ar": "الثلاثاء"},
    {"key": "wednesday", "ar": "الأربعاء"},
    {"key": "thursday", "ar": "الخميس"},
    {"key": "friday", "ar": "الجمعة"},
    {"key": "saturday", "ar": "السبت"},
  ];

  var holidays = <String>[].obs;
  final maxHolidays = 2.obs;
  final shake = false.obs;

  void toggleHoliday(String day) {
    if (holidays.contains(day)) {
      holidays.remove(day);
      return;
    }

    if (holidays.length >= maxHolidays.value) {
      triggerShake();
      return;
    }

    holidays.add(day);
  }
  void triggerShake() {
    shake.value = true;

    Future.delayed(const Duration(milliseconds: 300), () {
      shake.value = false;
    });
  }

  Future<void> createPharmacy() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedRegion.value == null) {
      AppSnackBar.error("Please select your region first.".tr);
      return;
    }

    if (openTime.value == null || closeTime.value == null) {
      AppSnackBar.error("Please specify your opening and closing times.".tr);
      return;
    }

    final mapController = Get.find<MapHelperController>(tag: "addPharmacy");
    if (mapController.latitude.value == 0.0 ||
        mapController.longitude.value == 0.0) {
      AppSnackBar.error("Please locate the pharmacy on the map".tr);
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
        holidays: holidays,
      );

      final response = await PharmacyService.createPharmacy(requestData);

      if (response["isSuccess"] == true) {
        AppSnackBar.success("The pharmacy has been successfully added.".tr);
      }
      clearFields();
    } catch (e) {
      AppSnackBar.error("The preservation process failed.".tr);
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
    if (Get.isRegistered<MapHelperController>(tag: "addPharmacy")) {
      Get.delete<MapHelperController>(tag: "addPharmacy");
    }
    super.onClose();
  }
}
