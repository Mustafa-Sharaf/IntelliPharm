
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../services/ApiService.dart';
import 'PharmacySelector_Model.dart';

class PharmacySelectorController extends GetxController {
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;

  RxList<PharmacyModel> pharmacies = <PharmacyModel>[].obs;
  Rxn<PharmacyModel> selectedPharmacy = Rxn<PharmacyModel>();

  int currentPage = 1;
  int lastPage = 1;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchPharmacies();

    // الاستماع للتمرير للأسفل لجلب الصفحة التالية
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore.value &&
          currentPage < lastPage) {
        fetchMorePharmacies();
      }
    });
  }

  // بناء المسار مع البرامترات (استخدام name للبحث)
  String _buildUrl({required int page, String name = ''}) {
    String url = '/erp/v1/pharmacies?per_page=15&page_number=$page';
    if (name.trim().isNotEmpty) {
      url += '&name=${Uri.encodeComponent(name.trim())}';
    }
    return url;
  }

  // جلب أول دفعة (الصفحة الأولى أو عند البحث)
  Future<void> fetchPharmacies({String search = ''}) async {
    try {
      isLoading.value = true;
      currentPage = 1;

      final url = _buildUrl(page: currentPage, name: search);
      final response = await ApiService.get(url);

      if (response.data['isSuccess'] == true) {
        final List pharmaciesJson = response.data['data']['data'];
        pharmacies.value =
            pharmaciesJson.map((e) => PharmacyModel.fromJson(e)).toList();

        // تحديث رقم آخر صفحة من الـ meta
        lastPage = response.data['data']['meta']['last_page'] ?? 1;
      }
    } catch (e) {
      print("Error fetching pharmacies: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // جلب الصفحة التالية عند السكرول
  Future<void> fetchMorePharmacies() async {
    try {
      isLoadingMore.value = true;
      currentPage++;

      final url = _buildUrl(page: currentPage, name: searchController.text);
      final response = await ApiService.get(url);

      if (response.data['isSuccess'] == true) {
        final List pharmaciesJson = response.data['data']['data'];
        final newPharmacies =
        pharmaciesJson.map((e) => PharmacyModel.fromJson(e)).toList();

        pharmacies.addAll(newPharmacies);
      }
    } catch (e) {
      print("Error fetching more pharmacies: $e");
      currentPage--; // إرجاع الصفحة للسابقة في حال الخلل
    } finally {
      isLoadingMore.value = false;
    }
  }

  // فلترة مع تأخير بسيط (Debounce) لمنع كثرة الطلبات أثناء الكتابة
  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchPharmacies(search: query);
    });
  }

  void selectPharmacy(PharmacyModel pharmacy) {
    selectedPharmacy.value = pharmacy;
    Get.back();
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}