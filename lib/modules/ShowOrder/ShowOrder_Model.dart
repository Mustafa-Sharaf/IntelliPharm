

class OrderDetailsModel {
  final int id;
  final String pharmacyName;
  final String status;
  final String date;
  final String totalPrice;
  final String percentage;
  final String totalQuantity;
  final String notes;
  final String finalPrice;
  final List<OrderItemModel> items;

  OrderDetailsModel({
    required this.id,
    required this.pharmacyName,
    required this.status,
    required this.date,
    required this.totalPrice,
    required this.totalQuantity,
    required this.items,
    required this.notes,
    required this.percentage,
    required this.finalPrice,

  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      id: json['id'],
      pharmacyName: json['pharmacy']['name'] ?? '',
      status: (json['status'] ?? '').toString().toUpperCase(),
      date: json['created_at'] ?? '',
      totalPrice: "\$${json['total_amount']}",
      totalQuantity: json['total_quantity'].toString(),
      notes: json['notes'].toString(),
      percentage: json['percentage'].toString(),
      finalPrice: json['final_total'].toString(),
      items: (json['items'] as List)
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
    );
  }
}

class OrderItemModel {
  final int medicineId;
  final String medicineName;
  final int quantity;
  final String unitPrice;
  final String totalPrice;
  final int gift;

  OrderItemModel({
    required this.medicineId,
    required this.medicineName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.gift,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      medicineId: json['medicine_id'] ?? 0,
      medicineName: json['medicine']['commercial_name'] ?? '',
      quantity: json['quantity'],
      unitPrice: json['unit_price'],
      totalPrice: json['total_price'],
      gift: json['is_gift'],
    );
  }
}

