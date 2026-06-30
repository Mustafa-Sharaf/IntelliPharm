import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/AppSnackBar.dart';
import '../../services/ServiceApi/NoteService.dart';



class AddNotesController extends GetxController {
  final int pharmacyId = Get.arguments;

  var selectedType = "GENERAL".obs;
  var isSubmitting = false.obs;

  late TextEditingController textController;

  @override
  void onInit() {
    super.onInit();
    textController = TextEditingController();
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
        noteType: selectedType.value,
        noteContent: noteText,
      );

      textController.clear();

  /*    if (Get.isRegistered<PharmacyDetailsController>(tag: pharmacyId.toString())) {
        final detailsController = Get.find<PharmacyDetailsController>(tag: pharmacyId.toString());

        // detailsController.getPharmacyNotes();
      }*/
      AppSnackBar.success("The note was added successfully.");

    } catch (e) {
      AppSnackBar.error("The message failed to send, please try again later.");
    } finally {
      isSubmitting.value = false;
    }
  }
}