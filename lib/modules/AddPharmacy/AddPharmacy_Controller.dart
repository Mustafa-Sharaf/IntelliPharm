import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../app_theme/AppColors.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../../services/ApiService.dart';
import 'AddPharmacy_Model.dart';

class AddPharmacyController extends GetxController {
  var pharmacyNameController = TextEditingController();
  var pharmacistsNameController = TextEditingController();
  var commentsController = TextEditingController();
  var phoneControllers = <TextEditingController>[TextEditingController()].obs;
  var openTime = Rx<TimeOfDay?>(null);
  var closeTime = Rx<TimeOfDay?>(null);
  LatLng? tempPosition;

  void addPhoneField() {
    if (phoneControllers.length < 2) {
      phoneControllers.add(TextEditingController());
    }
  }

  void removePhoneField(int index) {
    if (phoneControllers.length > 1) {
      phoneControllers[index].dispose();
      phoneControllers.removeAt(index);
    }
  }

  Future<void> pickTime({
    required BuildContext context,
    required Rx<TimeOfDay?> targetTime,
    required Color backgroundColor,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: targetTime.value ?? TimeOfDay.now(),

      builder: (context, child) {
        final isDark = Get.isDarkMode;

        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: backgroundColor,
              hourMinuteColor: AppColors.primaryColor,
              hourMinuteTextColor: AppColors.gray,
              dialHandColor: AppColors.primaryColor,
              entryModeIconColor: AppColors.primaryColor,
              dayPeriodTextColor: AppColors.gray,
              dayPeriodColor: isDark
                  ? Colors.grey.shade800
                  : Colors.grey.shade200,
              helpTextStyle: const TextStyle(
                color: AppColors.gray,
                fontFamily: 'Cairo',
              ),
            ),
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      targetTime.value = picked;
    }
  }



  Future<void> addPharmacy() async {
    try {
      if (openTime.value == null || closeTime.value == null) {
        Get.snackbar("Error", "Please select working hours");
        return;
      }

      final mapController = Get.find<MapHelperController>(tag: "addPharmacy");

      final pharmacy = PharmacyModel(
        regionId: 1,
        name: pharmacyNameController.text,
        latitude: mapController.latitude.value,
        longitude: mapController.longitude.value,
        openingTime: formatTime(openTime.value!),
        closingTime: formatTime(closeTime.value!),
        isActive: true,
        pharmacistName: pharmacistsNameController.text,
        pharmacistPhone: phoneControllers[0].text,
        pharmacistAlt: phoneControllers.length > 1
            ? phoneControllers[1].text
            : null,
      );

      final response = await ApiService.post(
        "/erp/v1/pharmacies",
        data: pharmacy.toJson(),
      );

      if (response.data["isSuccess"]) {
        Get.snackbar("Success", "Pharmacy added successfully");
        Get.back();
      } else {
        Get.snackbar("Error", response.data["message"]);
      }
    } catch (e) {
      print("❌ Error: $e");
      Get.snackbar("Error", "Something went wrong");
    }
  }
  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  @override
  void onClose() {
    pharmacyNameController.dispose();
    pharmacistsNameController.dispose();
    commentsController.dispose();
    for (var c in phoneControllers) {
      c.dispose();
    }
    super.onClose();
  }
}
