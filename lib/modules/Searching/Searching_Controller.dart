import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/ServiceApi/MedicineService.dart';
import 'Searching_Model.dart';


class SearchingController extends GetxController {
  var searchController = TextEditingController();

  var medicines = <Medicine>[].obs;
  var suggestions = <Medicine>[].obs;

  var isLoading = false.obs;
  var isLoadingMore = false.obs;

  var hasMore = true.obs;
  var searchText = "".obs;

  int page = 1;

  Timer? _debounce;

  /// 🔥 caching
  final Map<String, List<Medicine>> cache = {};

  /// 🔥 scroll
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    scrollController.addListener(_onScroll);
    super.onInit();
  }

  /// =========================
  /// 🔥 FETCH (with caching)
  /// =========================
  Future<void> fetchMedicines({String query = ""}) async {
    try {
      if (query.isEmpty) {
        medicines.clear();
        return;
      }

      /// ✅ cache hit
      if (cache.containsKey(query) && page == 1) {
        medicines.assignAll(cache[query]!);
        return;
      }

      isLoading.value = true;

      final data = await MedicineService.getMedicines(
        page: page,
        query: query,
      );

      if (data["isSuccess"]) {
        final List list = data["data"]["data"];

        final newData =
        list.map((e) => Medicine.fromJson(e)).toList();

        medicines.assignAll(newData);

        /// ✅ save cache
        cache[query] = newData;

        hasMore.value = list.isNotEmpty;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch medicines");
    } finally {
      isLoading.value = false;
    }
  }

  /// =========================
  /// 🔥 LOAD MORE (Infinite Scroll)
  /// =========================
  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value) return;

    try {
      isLoadingMore.value = true;
      page++;

      final data = await MedicineService.getMedicines(
        page: page,
        query: searchController.text,
      );

      if (data["isSuccess"]) {
        final List list = data["data"]["data"];

        final moreData =
        list.map((e) => Medicine.fromJson(e)).toList();

        medicines.addAll(moreData);

        if (list.isEmpty) {
          hasMore.value = false;
        }
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 100) {
      loadMore();
    }
  }

  /// =========================
  /// 🔍 SEARCH + Suggestions
  /// =========================
  void onSearchChanged(String value) {
    searchText.value = value; // ✅ مهم

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (value.trim().isEmpty) {
        medicines.clear();
        suggestions.clear();
        return;
      }

      page = 1;
      fetchSuggestions(value);
      fetchMedicines(query: value);
    });
  }

  Future<void> fetchSuggestions(String query) async {
    final data = await MedicineService.getMedicines(
      page: 1,
      query: query,
    );

    if (data["isSuccess"]) {
      final List list = data["data"]["data"];

      suggestions.assignAll(
        list.map((e) => Medicine.fromJson(e)).toList(),
      );
    }
  }

  void onSuggestionTap(Medicine med) {
    searchController.text = med.name;
    page = 1;
    fetchMedicines(query: med.name);
  }

  @override
  void onClose() {
    _debounce?.cancel();
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }
}