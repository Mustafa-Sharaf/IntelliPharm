/*
import 'package:get/get.dart';

import '../../helper/mapHelper/dart/LocationHelperService.dart';
import '../../services/ServiceApi/PharmacyDetailsService.dart';
import 'PharmacyDetails_Model.dart';


class PharmacyDetailsController extends GetxController {
  final int pharmacyId;
  PharmacyDetailsController({required this.pharmacyId});

  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = "".obs;
  var pharmacyData = Rxn<PharmacyDetailsModel>();
  var actualAddress = "جاري جلب العنوان الفعلي...".obs;

  var selectedFilter = "ALL".obs;

  @override
  void onInit() {
    super.onInit();
    fetchPharmacyDetails();
  }

  Future<void> fetchPharmacyDetails() async {
    try {
      isLoading(true);
      isError(false);


      final data = await PharmacyDetailsService.getPharmacyDetails(pharmacyId);
      print("pharmacyId= $pharmacyId");
      pharmacyData.value = data;

      if (data.latitude != 0.0) {
        actualAddress.value = await LocationHelperService.getAddressFromCoordinates(
          data.latitude,
          data.longitude,
        );
      } else {
        actualAddress.value = "الإحداثيات غير متوفرة لهذه الصيدلية";
      }

    } catch (e) {
      isError(true);
      errorMessage.value = e.toString().replaceAll("Exception:", "");
      print("Error in PharmacyDetailsController: $e");
    } finally {
      isLoading(false);
    }
  }

  List<HistoryNote> get filteredNotes {
    if (pharmacyData.value == null) return [];
    if (selectedFilter.value == "ALL") return pharmacyData.value!.historyNotes;
    return pharmacyData.value!.historyNotes
        .where((note) => note.noteType.toUpperCase() == selectedFilter.value)
        .toList();
  }
}*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helper/mapHelper/dart/LocationHelperService.dart';
import '../../services/ServiceApi/PharmacyDetailsService.dart';
import '../../services/ServiceApi/PharmacyNotesService.dart';
import 'AddNotes/AddNotes_Model.dart';
import 'PharmacyDetails_Model.dart';


class PharmacyDetailsController extends GetxController {
  final int pharmacyId;
  PharmacyDetailsController({required this.pharmacyId});

  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = "".obs;
  var pharmacyData = Rxn<PharmacyDetailsModel>();
  var actualAddress = "جاري جلب العنوان الفعلي...".obs;

  // حقول الفلترة والإضافة المحددة
  var selectedFilter = "ALL".obs; // للفلترة العلوية بالـ UI
  var activeNoteType = "GENERAL".obs; // النوع المختار حالياً عند كتابة ملاحظة جديدة ⭐

  // تحكم بحقل الإدخال وحالة تحميل زر الإرسال
  final textController = TextEditingController();
  var isSendingNote = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPharmacyDetails();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  Future<void> fetchPharmacyDetails() async {
    try {
      isLoading(true);
      isError(false);
      final data = await PharmacyDetailsService.getPharmacyDetails(pharmacyId);
      pharmacyData.value = data;

      if (data.latitude != 0.0) {
        actualAddress.value = await LocationHelperService.getAddressFromCoordinates(
          data.latitude,
          data.longitude,
        );
      } else {
        actualAddress.value = "الإحداثيات غير متوفرة لهذه الصيدلية";
      }
    } catch (e) {
      isError(true);
      errorMessage.value = e.toString().replaceAll("Exception:", "");
    } finally {
      isLoading(false);
    }
  }

  // 📝 دالة إرسال الملاحظة الجديدة للسيرفر
  Future<void> submitNewNote() async {
    final noteText = textController.text.trim();

    if (noteText.isEmpty) {
      Get.snackbar("تنبيه", "الرجاء كتابة نص الملاحظة أولاً",
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.amber.shade100);
      return;
    }

    try {
      isSendingNote(true);

      final newNote = CreateNoteModel(
        noteType: activeNoteType.value,
        note: noteText,
      );

      final success = await PharmacyNotesService.addPharmacyNote(
        pharmacyId: pharmacyId,
        noteData: newNote,
      );

      if (success) {
        textController.clear(); // تفريغ الحقل بعد النجاح
        activeNoteType.value = "GENERAL"; // إعادة النوع للافتراضي

        // 🔄 سحب البيانات من جديد لتحديث قائمة الملاحظات بالـ UI فوراً!
        await fetchPharmacyDetails();

        Get.snackbar("نجاح", "تمت إضافة الملاحظة بنجاح",
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.green.shade100);
      }
    } catch (e) {
      Get.snackbar("خطأ", e.toString().replaceAll("Exception:", ""),
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.red.shade100);
    } finally {
      isSendingNote(false);
    }
  }

  List<HistoryNote> get filteredNotes {
    if (pharmacyData.value == null) return [];
    if (selectedFilter.value == "ALL") return pharmacyData.value!.historyNotes;
    return pharmacyData.value!.historyNotes
        .where((note) => note.noteType.toUpperCase() == selectedFilter.value)
        .toList();
  }
}