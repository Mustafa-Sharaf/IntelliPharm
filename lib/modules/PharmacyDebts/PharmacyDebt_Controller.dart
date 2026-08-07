

import 'package:flutter/foundation.dart';
import 'PharmacyDebt_Model.dart';
import 'package:get/get.dart';


class PharmacyDebtController {


  List<PharmacyDebtModel> _allDebts = [];

  final ValueNotifier<List<PharmacyDebtModel>> filteredDebtsNotifier = ValueNotifier([]);
  final ValueNotifier<String> selectedFilterNotifier = ValueNotifier('All');


  var searchQuery = "".obs;

  double get totalBilled => _allDebts.fold(0, (sum, item) => sum + item.totalAmount);
  double get totalCollected => _allDebts.fold(0, (sum, item) => sum + item.paidAmount);
  double get totalOutstanding => totalBilled - totalCollected;
  double get collectedPercentage => totalBilled == 0 ? 0 : (totalCollected / totalBilled);

  Future<void> loadDebts() async {
    _allDebts = await fetchPharmacyDebts();
    _applyFilter();
  }

  void filterByStatus(String filter) {
    selectedFilterNotifier.value = filter;
    _applyFilter();
  }

  void updateSearch(String value) {
    searchQuery.value = value;
    _applyFilter();
  }



  Future<List<PharmacyDebtModel>> fetchPharmacyDebts() async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 300));

    // البيانات التجريبية المطابقة للصورة
    return [
      PharmacyDebtModel(
        id: '1',
        name: 'CityHealth Pharmacy',
        location: 'Downtown District',
        totalAmount: 10000,
        paidAmount: 1500,
        lastPaymentDate: 'Mar 15, 2026',
        status: PaymentStatus.overdue,
      ),
      PharmacyDebtModel(
        id: '2',
        name: 'MediCare Plus',
        location: 'Northside Area',
        totalAmount: 12000,
        paidAmount: 8500,
        lastPaymentDate: 'Apr 1, 2026',
        status: PaymentStatus.partial,
      ),
      PharmacyDebtModel(
        id: '3',
        name: 'Wellness Rx',
        location: 'West End Village',
        totalAmount: 32000,
        paidAmount: 32000,
        lastPaymentDate: 'Apr 3, 2026',
        status: PaymentStatus.paid,
      ),
    ];
  }


  void _applyFilter() {
    filteredDebtsNotifier.value = _allDebts.where((item) {
      final matchesSearch = item.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.location.toLowerCase().contains(searchQuery.toLowerCase());

      bool matchesStatus = true;
      if (selectedFilterNotifier.value == 'Fully Paid') {
        matchesStatus = item.status == PaymentStatus.paid;
      } else if (selectedFilterNotifier.value == 'Partially Paid') {
        matchesStatus = item.status == PaymentStatus.partial;
      } else if (selectedFilterNotifier.value == 'Overdue') {
        matchesStatus = item.status == PaymentStatus.overdue;
      }

      return matchesSearch && matchesStatus;
    }).toList();
  }
}