
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../Widgets/AppSnackBar.dart';
import '../../services/ServiceApi/OrderCancelService.dart';
import '../../services/ServiceApi/OrderFetchService.dart';
import 'MyOrders_Model.dart';
class MyOrdersController extends GetxController {
  var selectedTab = 0.obs;
  var isFetching = false;

  List<String> get tabs => [
    "All".tr,
    "Pending".tr,
    "Processing".tr,
    "OnTheWay".tr,
    "Completed".tr,
    "Cancelled".tr,
  ];

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
        //print("Status Code: ${e.response?.statusCode}");
       // print("Response Data: ${e.response?.data}");
        //print("Request Path: ${e.requestOptions.path}");

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
        return allOrders.where((o) => o.status.toUpperCase() == "PENDING").toList();

      case 2:
        return allOrders.where((o) => o.status.toUpperCase() == "PROCESSING").toList();

      case 3:
        return allOrders
            .where((o) =>
        o.status.toUpperCase() == "ON THE WAY" ||
            o.status.toUpperCase() == "ON_THE_WAY")
            .toList();

      case 4:
        return allOrders.where((o) => o.status.toUpperCase() == "COMPLETED").toList();

      case 5:
        return allOrders.where((o) => o.status.toUpperCase() == "CANCELLED").toList();

      default:
        return allOrders;
    }
  }

  void cancelOrder(int orderId) async {
    try {
      Get.dialog(
        Center(child: CircularProgressIndicator(color: AppColors.primaryColor,)),
        barrierDismissible: false,
      );

      final isSuccess = await OrderCancelService.cancelOrder(orderId);

      Get.back();

      if (isSuccess) {
        AppSnackBar.success("Order_cancelled_successfully".tr);
        fetchOrders();
      }
    } catch (e) {

      Get.back();
      AppSnackBar.error("Failed_to_cancel_order".tr);
    }
  }


  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}