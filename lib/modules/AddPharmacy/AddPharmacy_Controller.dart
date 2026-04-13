/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Validation/LocationValidation.dart';
import '../../Validation/RegionValidation.dart';
import '../../Validation/empty_fields_validation.dart';
import '../../Validation/phone_validation.dart';
import '../../Validation/validation_context.dart';
import '../../Widgets/AppSnackBar.dart';
import '../../Widgets/RegionSelector/RegionSelector_Model.dart';
import '../../helper/Time/dart/timeHelper.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../../services/ServiceApi/PharmacyService.dart';
import 'AddPharmacy_Model.dart';

class AddPharmacyController extends GetxController {
  ///Definitions of variables
  var pharmacyNameController = TextEditingController();
  var pharmacistsNameController = TextEditingController();
  var phoneControllers = <TextEditingController>[TextEditingController()].obs;
  var openTime = Rx<TimeOfDay?>(null);
  var closeTime = Rx<TimeOfDay?>(null);
  LatLng? tempPosition;
  var selectedRegion = Rxn<RegionModel>();
  var isLoading = false.obs;
  final mapController = Get.find<MapHelperController>(tag: "addPharmacy");

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

  ///Time selection
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

  ///Verification
  Future<void> createPharmacy() async {
    try {
      final validation = ValidationContext([
        EmptyFieldsValidation([
          pharmacyNameController.text,
          pharmacistsNameController.text,
          phoneControllers[0].text,
          openTime.value?.toString() ?? "",
          closeTime.value?.toString() ?? "",
        ]),
        PhoneValidation(phoneControllers[0].text),
        RegionValidation(selectedRegion.value),
        LocationValidation(
          mapController.latitude.value,
          mapController.longitude.value,
        ),
      ]);
      final error = validation.validateAll();
      if (error != null) {
        AppSnackBar.error(error);
        return;
      }
      isLoading.value = true;

      ///Create Pharmacy
      final request = PharmacyModel(
        nameAr: pharmacyNameController.text,
        nameEn: pharmacyNameController.text,
        regionId: selectedRegion.value!.id,
        latitude: mapController.latitude.value,
        longitude: mapController.longitude.value,
        openingTime: TimeHelper.formatTime(openTime.value!),
        closingTime: TimeHelper.formatTime(closeTime.value!),
        isActive: true,
        pharmacistName: pharmacistsNameController.text,
        pharmacistPhone: phoneControllers[0].text,
        pharmacistAltPhone: phoneControllers.length > 1
            ? phoneControllers[1].text
            : null,
      );

      final response = await PharmacyService.createPharmacy(request);
      if (response["isSuccess"] == true) {
        AppSnackBar.success("Pharmacy_created_successfully".tr);
        Get.offAllNamed("/homeScreen");
      } else {
        AppSnackBar.error(response["message"]);
      }
    } catch (e) {
      AppSnackBar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    pharmacyNameController.dispose();
    pharmacistsNameController.dispose();
    for (var c in phoneControllers) {
      c.dispose();
    }
    super.onClose();
  }
}
*/
