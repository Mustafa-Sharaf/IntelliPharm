import 'dart:async'; // 🟢 لاستخدام Timer
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/ServiceApi/DebtsResponseService.dart';
import 'PharmacyDebt_Model.dart';

class PharmacyDebtController extends GetxController {
  final List<PharmacyDebtModel> _allDebts = [];

  final ValueNotifier<List<PharmacyDebtModel>> filteredDebtsNotifier = ValueNotifier([]);
  final ValueNotifier<String> selectedFilterNotifier = ValueNotifier('All');

  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  var searchQuery = "".obs;

  Timer? _debounce; // 🟢 مؤشر للتحكم بمهلة البحث

  int _currentPage = 1;
  bool _hasNextPage = true;

  double _totalBilled = 0.0;
  double _totalCollected = 0.0;
  double _totalOutstanding = 0.0;

  double get totalBilled => _totalBilled;
  double get totalCollected => _totalCollected;
  double get totalOutstanding => _totalOutstanding;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadDebts();

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        loadMoreDebts();
      }
    });
  }

  /// 🟢 تحديث نص البحث مع تأخير 400ms لتنعيم الأداء لمنع التعليق
  void updateSearch(String value) {
    searchQuery.value = value;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _applyFilter();
    });
  }

  void filterByStatus(String filter) {
    selectedFilterNotifier.value = filter;
    _applyFilter();
  }

  void _applyFilter() {
    final query = searchQuery.value.trim().toLowerCase();

    // 🟢 تحسين الأداء: إذا كان البحث فارغاً والفلتر "الكل"، نعيد القائمة الأصلية مباشرة دون عمليات البحث والتكرار
    if (query.isEmpty && selectedFilterNotifier.value == 'All') {
      filteredDebtsNotifier.value = List.from(_allDebts);
      return;
    }

    filteredDebtsNotifier.value = _allDebts.where((item) {
      final matchesSearch = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.location.toLowerCase().contains(query);

      bool matchesStatus = true;
      if (selectedFilterNotifier.value == 'Fully Paid') {
        matchesStatus = item.status == PaymentStatus.paid;
      } else if (selectedFilterNotifier.value == 'Partially Paid') {
        matchesStatus = item.status == PaymentStatus.partial;
      } else if (selectedFilterNotifier.value == 'Overdue') {
        matchesStatus = item.status == PaymentStatus.overdue;
      } else if (selectedFilterNotifier.value == 'Pending') {
        matchesStatus = item.status == PaymentStatus.pending;
      }

      return matchesSearch && matchesStatus;
    }).toList();
  }

  Future<void> loadDebts() async {
    try {
      isLoading.value = true;
      _currentPage = 1;
      _hasNextPage = true;
      _allDebts.clear();

      final response = await DebtsService.getDebts(page: _currentPage);

      _allDebts.addAll(response.debts);
      _totalBilled = response.totalDebtAmount;
      _totalCollected = response.totalPaid;
      _totalOutstanding = response.totalRemaining;

      if (response.debts.length < 15 || _currentPage >= response.lastPage) {
        _hasNextPage = false;
      }

      _applyFilter();
    } catch (e) {
      print("Error loading debts: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreDebts() async {
    if (isLoadingMore.value || !_hasNextPage || isLoading.value) return;

    try {
      isLoadingMore.value = true;
      _currentPage++;

      final response = await DebtsService.getDebts(page: _currentPage);

      if (response.debts.isEmpty || _currentPage >= response.lastPage) {
        _hasNextPage = false;
      }

      _allDebts.addAll(response.debts);
      _applyFilter();
    } catch (e) {
      print("Error loading more debts: $e");
      _currentPage--;
    } finally {
      isLoadingMore.value = false;
    }
  }

  @override
  void onClose() {
    _debounce?.cancel(); // 🟢 إلغاء الـ Timer عند إغلاق الشاشة
    scrollController.dispose();
    super.onClose();
  }
}