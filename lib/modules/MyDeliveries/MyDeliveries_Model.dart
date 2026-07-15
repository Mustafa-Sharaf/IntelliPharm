
enum DeliveryTab { pending, inTransit, delivered, all }
enum OrderPriority { urgent, normal, low }
enum OrderStatus { pending, inTransit, delivered, cancelled }

class DeliveryOrderModel {
  final String orderId;
  final String clientName;
  final String pharmacistName;
  final int itemsCount;
  final double price;
  final String scheduledTime;
  final String createdAt;
  final OrderStatus status;
  final OrderPriority priority;

  DeliveryOrderModel({
    required this.orderId,
    required this.clientName,
    required this.pharmacistName,
    required this.itemsCount,
    required this.price,
    required this.scheduledTime,
    required this.createdAt,
    required this.status,
    this.priority = OrderPriority.normal,
  });

  factory DeliveryOrderModel.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderModel(
      orderId: (json['order_id'] ?? '').toString(),
      clientName: json['pharmacy_name'] ?? '',
      pharmacistName: json['pharmacist_name'] ?? '',
      itemsCount: json['number_of_items'] ?? 0,
      price: double.tryParse((json['required_payment_amount'] ?? '0').toString()) ?? 0.0,
      scheduledTime: json['scheduled_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      status: _parseStatus(json['status']),
    );
  }

  static OrderStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'in_progress':
        return OrderStatus.inTransit;
      case 'completed':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'pending':
      default:
        return OrderStatus.pending;
    }
  }
}