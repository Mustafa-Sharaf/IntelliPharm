import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/ServiceApi/NoteService.dart';
import '../PharmacyDetails/PharmacyDetails_Controller.dart';


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
      Get.snackbar("تنبيه", "الرجاء كتابة ملاحظة أولاً", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isSubmitting.value = true;

      // 🚀 استدعاء السيرفس الموحد بـ Dio
      await NoteService.createNote(
        pharmacyId: pharmacyId,
        noteType: selectedType.value,
        noteContent: noteText,
      );

      // تفريغ الحقل بعد النجاح
      textController.clear();

      // 🔄 التحديث التلقائي الفوري: نقوم بالبحث عن كونترولر التفاصيل الفعال لهذا الـ ID وتحديثه
      if (Get.isRegistered<PharmacyDetailsController>(tag: pharmacyId.toString())) {
        final detailsController = Get.find<PharmacyDetailsController>(tag: pharmacyId.toString());

        // استدعاء دالة جلب الملاحظات لتحديث الـ Obx فوراً بالواجهة (تأكد من اسم الدالة لديك بالكونترولر الخاص بك)
        // detailsController.getPharmacyNotes();
      }

      Get.snackbar("نجاح", "تمت إضافة الملاحظة بنجاح", snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("خطأ", "فشل إرسال الملاحظة، يرجى المحاولة لاحقاً", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
    }
  }
}