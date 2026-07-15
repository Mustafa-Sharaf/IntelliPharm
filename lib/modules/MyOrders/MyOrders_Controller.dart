
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../services/ServiceApi/OrderFetchService.dart';
import 'MyOrders_Model.dart';

class MyOrdersController extends GetxController {
  var selectedTab = 0.obs;
  var isFetching = false;

  final tabs = ["All".tr, "Pending".tr, "Processing".tr, "Completed".tr,"Cancelled".tr];

  var allOrders = <OrderModel>[].obs;
  var isLoading = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    fetchOrders();
    _startAutoRefresh();
    super.onInit();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      fetchOrders(silent: true);
    });
  }

  void fetchOrders({bool silent = false}) async {
    if (isFetching) return;

    isFetching = true;

    if (!silent) isLoading.value = true;

    try {
      final newData = await OrderFetchService.getOrders();

      if (!listEquals(allOrders, newData)) {
        allOrders.value = newData;
      }
    } catch (e) {
      if (e is DioException) {
        print("Status Code: ${e.response?.statusCode}");
        print("Response Data: ${e.response?.data}");
        print("Request Path: ${e.requestOptions.path}");

        if (e.response?.statusCode == 500) {
          print("Server Error 500");
        }
      } else {
        print("Unexpected Error: $e");
      }
    } finally {
      isFetching = false;
      if (!silent) isLoading.value = false;
    }
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  List<OrderModel> get filteredOrders {
    switch (selectedTab.value) {
      case 1:
        return allOrders.where((o) => o.status == "PENDING").toList();

      case 2:
        return allOrders.where((o) => o.status == "PROCESSING").toList();

      case 3:
        return allOrders.where((o) => o.status == "COMPLETED").toList();
      case 4:
        return allOrders.where((o) => o.status == "CANCELLED").toList();

      default:
        return allOrders;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}