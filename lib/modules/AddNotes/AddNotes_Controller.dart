import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/AppSnackBar.dart';
import '../../services/ServiceApi/NoteService.dart';
import '../PharmacyDetails/PharmacyDetails_Controller.dart';

class AddNotesController extends GetxController {
  late final int pharmacyId;
  var selectedType = "GENERAL".obs;
  var isSubmitting = false.obs;
  late TextEditingController textController;

  @override
  void onInit() {
    super.onInit();
    textController = TextEditingController();
    if (Get.arguments is int) {
      pharmacyId = Get.arguments;
    } else if (Get.arguments is Map) {
      pharmacyId = Get.arguments['pharmacyId'] ?? Get.arguments['id'] ?? 0;
    } else {
      pharmacyId = int.tryParse(Get.arguments.toString()) ?? 0;
    }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  void changeSelectedType(String type) {
    selectedType.value = type;
  }

  Future<void> submitNote() async {
    final noteText = textController.text.trim();
    if (noteText.isEmpty) {
      AppSnackBar.error("Please write a note first.");
      return;
    }

    try {
      isSubmitting.value = true;

      await NoteService.createNote(
        pharmacyId: pharmacyId,
        noteType: selectedType.value.toLowerCase(),
        noteContent: noteText,
      );

      final tagStr = pharmacyId.toString();
      if (Get.isRegistered<PharmacyDetailsController>(tag: tagStr)) {
        final pharmacyCtrl = Get.find<PharmacyDetailsController>(tag: tagStr);
        await pharmacyCtrl.fetchPharmacyDetails();
      }

      textController.clear();
      AppSnackBar.success("The note was added successfully.");

    } catch (e) {
      //print("SUBMIT NOTE ERROR: $e");
      AppSnackBar.error("The message failed to send, please try again later.");
    } finally {
      isSubmitting.value = false;
    }
  }
}