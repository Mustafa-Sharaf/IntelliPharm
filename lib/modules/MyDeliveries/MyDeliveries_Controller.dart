
/*
import 'package:get/get.dart';

enum DeliveryTab { pending, inTransit, delivered, all }
enum OrderPriority { urgent, normal, low }
enum OrderStatus { pending, inTransit, delivered }


class DeliveryOrderModel {
  final String orderId;
  final String clientName;
  final String address;
  final int itemsCount;
  final double price;
  final String estTime;
  final String assignedTime;
  final OrderPriority priority;
  final OrderStatus status;
  final bool isHospital;

  DeliveryOrderModel({
    required this.orderId,
    required this.clientName,
    required this.address,
    required this.itemsCount,
    required this.price,
    required this.estTime,
    required this.assignedTime,
    required this.priority,
    required this.status,
    required this.isHospital,
  });
}

class MyDeliveriesController extends GetxController {
  var currentTab = DeliveryTab.pending.obs;


  final List<DeliveryOrderModel> allOrders = [
    DeliveryOrderModel(
      orderId: "ORD-4921",
      clientName: "Al-Amal Pharmacy",
      address: "42nd Medical District, Sector 5, North Wing...",
      itemsCount: 12,
      price: 240.50,
      estTime: "10:15 AM",
      assignedTime: "08:30 AM",
      priority: OrderPriority.urgent,
      status: OrderStatus.pending,
      isHospital: false,
    ),
    DeliveryOrderModel(
      orderId: "ORD-5012",
      clientName: "City General Hospital",
      address: "Main Plaza, Building B, Emergency Entrance",
      itemsCount: 45,
      price: 1850.00,
      estTime: "11:45 AM",
      assignedTime: "08:30 AM",
      priority: OrderPriority.normal,
      status: OrderStatus.pending,
      isHospital: true,
    ),
    DeliveryOrderModel(
      orderId: "ORD-4889",
      clientName: "Ibn Sina Pharmacy",
      address: "Al-Tijara Street, Near Square",
      itemsCount: 20,
      price: 410.00,
      estTime: "01:15 PM",
      assignedTime: "09:00 AM",
      priority: OrderPriority.normal,
      status: OrderStatus.inTransit,
      isHospital: false,
    ),
    DeliveryOrderModel(
      orderId: "ORD-4752",
      clientName: "Al-Shifa Pharmacy",
      address: "Al-Mazza Highway, Next to Akram Mosque",
      itemsCount: 15,
      price: 320.00,
      estTime: "03:30 PM",
      assignedTime: "09:30 AM",
      priority: OrderPriority.urgent,
      status: OrderStatus.inTransit,
      isHospital: false,
    ),
    DeliveryOrderModel(
      orderId: "ORD-4610",
      clientName: "Damascus Central Lab",
      address: "Baghdad Street, Medical Towers",
      itemsCount: 8,
      price: 150.25,
      estTime: "04:00 PM",
      assignedTime: "10:00 AM",
      priority: OrderPriority.low,
      status: OrderStatus.delivered,
      isHospital: true,
    ),
  ];


  List<DeliveryOrderModel> get filteredOrders {
    switch (currentTab.value) {
      case DeliveryTab.pending:
        return allOrders.where((o) => o.status == OrderStatus.pending).toList();
      case DeliveryTab.inTransit:
        return allOrders.where((o) => o.status == OrderStatus.inTransit).toList();
      case DeliveryTab.delivered:
        return allOrders.where((o) => o.status == OrderStatus.delivered).toList();
      case DeliveryTab.all:
        return allOrders;
    }
  }

  void changeTab(DeliveryTab tab) {
    currentTab.value = tab;
  }

  void startDelivery(String orderId) {
    Get.snackbar(
      "Delivery Started",
      "Order $orderId is now in transit.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}*/
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