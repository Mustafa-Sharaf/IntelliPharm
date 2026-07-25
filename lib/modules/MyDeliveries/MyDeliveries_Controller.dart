

import 'package:get/get.dart';
import '../../services/ServiceApi/MyDeliveriesService.dart';
import 'MyDeliveries_Model.dart';


class MyDeliveriesController extends GetxController {
  var isLoading = true.obs;
  var currentTab = DeliveryTab.pending.obs;
  var ordersList = <DeliveryOrderModel>[].obs;

  // إحصائيات سريعة للـ Summary Bar
  var pendingCount = 0.obs;
  var inTransitCount = 0.obs;
  var deliveredCount = 0.obs;

  @override
  void onInit() {
    fetchDeliveries();
    super.onInit();
  }

  // لتغيير التبويب وجلب بيانات جديدة مفلترة من السيرفر مباشرة
  void changeTab(DeliveryTab tab) {
    currentTab.value = tab;
    fetchDeliveries();
  }

  Future<void> fetchDeliveries() async {
    try {
      isLoading(true);

      // تحويل تبويب التطبيق إلى الحالة المقابلة بالباك إند للفلترة
      String? backendStatus;
      switch (currentTab.value) {
        case DeliveryTab.pending:
          backendStatus = 'pending';
          break;
        case DeliveryTab.inTransit:
          backendStatus = 'in_progress';
          break;
        case DeliveryTab.delivered:
          backendStatus = 'completed';
          break;
        case DeliveryTab.all:
          backendStatus = null; // جلب الكل
          break;
      }

      final responseMap = await MyDeliveriesService.getMyDeliveries(status: backendStatus);

      if (responseMap['isSuccess'] == true) {
        final List rawList = responseMap['data']?['data'] ?? [];
        ordersList.value = rawList.map((json) => DeliveryOrderModel.fromJson(json)).toList();

        // تحديث إحصائيات الـ Summary Bar محلياً بناء على القائمة الحالية أو من الـ Meta
        _updateSummaryCounts();
      }
    } catch (e) {
      print("Error fetching deliveries: $e");
    } finally {
      isLoading(false);
    }
  }

  void _updateSummaryCounts() {
    // لحساب سريع وبسيط للحالات من القائمة المعروضة حالياً
    pendingCount.value = ordersList.where((o) => o.status == OrderStatus.pending).length;
    inTransitCount.value = ordersList.where((o) => o.status == OrderStatus.inTransit).length;
    deliveredCount.value = ordersList.where((o) => o.status == OrderStatus.delivered).length;
  }

  void startDelivery(String orderId) {
    Get.snackbar(
      "Delivery Started".tr,
      "${"Order".tr} $orderId ${"is now in transit.".tr}",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}