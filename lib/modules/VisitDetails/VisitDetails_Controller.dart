import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/AppSnackBar.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../../modules/VisitDetails/VisitDetails_Model.dart';
import '../../services/ServiceApi/VisitsService.dart';

class VisitDetailsController extends GetxController {

  var isLoading = false.obs;
  var pharmacyData = Rxn<dynamic>();

  var isSubmittingCheck = false.obs;
  final notesTextController = TextEditingController();



  Future<void> submitVisitCheck({required int visitId, required bool isUseful}) async {
    try {
      isSubmittingCheck.value = true;
      final mapHelper = Get.find<MapHelperController>(tag: "route");

      final request = VisitCheckModel(
        visited: true,
        useful: isUseful,
        currentLongitude: mapHelper.longitude.value,
        currentLatitude: mapHelper.latitude.value,
      );

      await VisitsService.checkVisit(visitId: visitId, requestData: request);
      AppSnackBar.success("Visit status updated successfully");


    } catch (e) {
      //print("CHECK VISIT ERROR: $e");
      AppSnackBar.error("An error occurred while saving the visit status.");
    } finally {
      isSubmittingCheck.value = false;
    }
  }

  @override
  void onClose() {
    notesTextController.dispose();
    super.onClose();
  }
}

