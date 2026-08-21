
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/AppSnackBar.dart';
import '../../services/ServiceApi/NoteService.dart';
import '../PharmacyDetails/PharmacyDetails_Controller.dart';
class AddNotesController extends GetxController {
  late final int pharmacyId;

  // اجعل القيمة الافتراضية مطابقة تماماً لما يتوقعه السيرفر (lowercase)
  var selectedType = "general".obs;
  var isSubmitting = false.obs;
  late TextEditingController textController;

  // قائمة بالأنواع المسموحة في الباك إند
  final List<String> allowedNoteTypes = ['general', 'tip', 'warning'];

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
    // التأكد من تحويل النوع إلى حروف صغيرة والتأكد أنه ضمن المسموح
    final cleanType = type.toLowerCase().trim();
    if (allowedNoteTypes.contains(cleanType)) {
      selectedType.value = cleanType;
    } else {
      selectedType.value = "general"; // fallback افتراضي
    }
  }

  Future<void> submitNote() async {
    final noteText = textController.text.trim();
    if (noteText.isEmpty) {
      AppSnackBar.error("Please write a note first.".tr);
      return;
    }

    try {
      isSubmitting.value = true;

      //  نرسل القيمة النظيفة مباشرة المحددة بـ general, tip, أو warning
      await NoteService.createNote(
        pharmacyId: pharmacyId,
        noteType: selectedType.value,
        noteContent: noteText,
      );

      final tagStr = pharmacyId.toString();
      if (Get.isRegistered<PharmacyDetailsController>(tag: tagStr)) {
        final pharmacyCtrl = Get.find<PharmacyDetailsController>(tag: tagStr);
        await pharmacyCtrl.fetchPharmacyDetails();
      }

      textController.clear();
      AppSnackBar.success("The note was added successfully.".tr);

    } catch (e) {
      AppSnackBar.error("The message failed to send, please try again later.".tr);
    } finally {
      isSubmitting.value = false;
    }
  }
}