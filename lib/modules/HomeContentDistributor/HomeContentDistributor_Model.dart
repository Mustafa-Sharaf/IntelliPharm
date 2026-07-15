import '../../Widgets/PharmacyOrderCard.dart';

class DeliveryHomeModel {
  final int totalAssigned;
  final int totalCompleted;
  final List<TodayDeliveryModel> todayDeliveries;

  DeliveryHomeModel({
    required this.totalAssigned,
    required this.totalCompleted,
    required this.todayDeliveries,
  });

  factory DeliveryHomeModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final stats = data['stats'] ?? {};
    final list = data['today_deliveries'] as List? ?? [];

    return DeliveryHomeModel(
      totalAssigned: stats['total_assigned_deliveries'] ?? 0,
      totalCompleted: stats['total_completed_deliveries'] ?? 0,
      todayDeliveries: list.map((item) => TodayDeliveryModel.fromJson(item)).toList(),
    );
  }
}

class TodayDeliveryModel {
  final int orderId;
  final String pharmacyName;
  final int itemsCount;
  final String urgency;

  TodayDeliveryModel({
    required this.orderId,
    required this.pharmacyName,
    required this.itemsCount,
    required this.urgency,
  });

  factory TodayDeliveryModel.fromJson(Map<String, dynamic> json) {
    return TodayDeliveryModel(
      orderId: json['order_id'] ?? 0,
      pharmacyName: json['pharmacy_name'] ?? '',
      itemsCount: json['number_of_items'] ?? 0,
      urgency: json['urgency'] ?? 'normal',
    );
  }
}


extension UrgencyParser on String {
  OrderPriority toOrderPriority() {
    switch (toLowerCase()) {
      case 'urgent':
        return OrderPriority.urgent;
      case 'low':
        return OrderPriority.low;
      case 'normal':
      default:
        return OrderPriority.normal;
    }
  }
}