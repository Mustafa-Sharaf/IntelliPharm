
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
}