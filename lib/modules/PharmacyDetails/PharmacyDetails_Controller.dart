/*

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helper/mapHelper/dart/LocationHelperService.dart';
import '../../services/ServiceApi/PharmacyDetailsService.dart';
import '../../services/ServiceApi/PharmacyNotesService.dart';
import '../AddNotes/AddNotes_Model.dart';
import 'PharmacyDetails_Model.dart';


class PharmacyDetailsController extends GetxController {
  late final int pharmacyId;
  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = "".obs;
  var pharmacyData = Rxn<PharmacyDetailsModel>();
  var actualAddress = "جاري جلب العنوان الفعلي...".obs;


  var selectedFilter = "ALL".obs;
  var activeNoteType = "GENERAL".obs;

  var isSendingNote = false.obs;

  @override
  void onInit() {
    super.onInit();
    pharmacyId = Get.arguments;
    fetchPharmacyDetails();
  }

  @override
  void onClose() {
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
import 'PharmacyDetails_Model.dart';

class PharmacyDetailsController extends GetxController {
  late final int pharmacyId;
  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = "".obs;
  var pharmacyData = Rxn<PharmacyDetailsModel>();
  var actualAddress = "جاري جلب العنوان الفعلي...".obs;

  // الفلتر الافتراضي يعرض الجميع "ALL"
  // الخيارات المتاحة للفلترة بناءً على الـ API هي: "ALL", "GENERAL", "WARNING", "TIP"
  var selectedFilter = "ALL".obs;
  var activeNoteType = "GENERAL".obs;
  var isSendingNote = false.obs;

  @override
  void onInit() {
    super.onInit();
    // حماية التطبيق في حال تمرير الـ arguments بشكل خاطئ
    if (Get.arguments is int) {
      pharmacyId = Get.arguments;
    } else if (Get.arguments is Map && Get.arguments['id'] != null) {
      pharmacyId = Get.arguments['id'];
    } else {
      pharmacyId = int.tryParse(Get.arguments.toString()) ?? 0;
    }

    fetchPharmacyDetails();
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

  // دالة تغيير الفلتر والتي يمكنك استدعاؤها عند الضغط على زر التصفية (Filter)
  void changeFilter(String filterType) {
    selectedFilter.value = filterType.toUpperCase();
  }

  // دالة الجلب المفلترة للملاحظات الثلاث (general, warning, tip)
  List<HistoryNote> get filteredNotes {
    if (pharmacyData.value == null) return [];

    // إذا كان الفلتر ALL، نعيد كافة الملاحظات
    if (selectedFilter.value == "ALL") {
      return pharmacyData.value!.historyNotes;
    }

    // الفلترة ومقارنة الأنواع بتحويلها لأحرف كبيرة لتجنب أي مشاكل تطابق
    return pharmacyData.value!.historyNotes
        .where((note) => note.noteType.toUpperCase() == selectedFilter.value)
        .toList();
  }
}