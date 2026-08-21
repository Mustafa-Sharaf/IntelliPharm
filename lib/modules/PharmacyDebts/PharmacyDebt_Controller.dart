import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../services/ServiceApi/DebtsResponseService.dart';
import 'PharmacyDebt_Model.dart';

class PharmacyDebtController extends GetxController {
  List<PharmacyDebtModel> _allDebts = [];

  final ValueNotifier<List<PharmacyDebtModel>> filteredDebtsNotifier =
  ValueNotifier([]);
  final ValueNotifier<String> selectedFilterNotifier = ValueNotifier('All');
  final RxBool isLoading = true.obs;
  var searchQuery = "".obs;
  double _totalBilled = 0.0;
  double _totalCollected = 0.0;
  double _totalOutstanding = 0.0;

  double get totalBilled => _totalBilled;
  double get totalCollected => _totalCollected;
  double get totalOutstanding => _totalOutstanding;
  double get collectedPercentage =>
      _totalBilled == 0 ? 0 : (_totalCollected / _totalBilled);

  @override
  void onInit() {
    super.onInit();
    loadDebts();
  }

  Future<void> loadDebts() async {
    try {
      isLoading.value = true;
      final response = await DebtsService.getDebts();
      _allDebts = response.debts;
      _totalBilled = response.totalDebtAmount;
      _totalCollected = response.totalPaid;
      _totalOutstanding = response.totalRemaining;

      _applyFilter();
    } catch (e) {
      print("Error loading debts: $e");
    } finally {
      isLoading.value = false; // لإيقاف مؤشر التحميل سواء نجح الطلب أو فشل
    }
  }

  void filterByStatus(String filter) {
    selectedFilterNotifier.value = filter;
    _applyFilter();
  }

  void updateSearch(String value) {
    searchQuery.value = value;
    _applyFilter();
  }

  void _applyFilter() {
    filteredDebtsNotifier.value = _allDebts.where((item) {
      final matchesSearch =
          item.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              item.location.toLowerCase().contains(searchQuery.value.toLowerCase());

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
}