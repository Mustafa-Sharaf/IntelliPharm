
class OrderModel {
  final int id;
  final String pharmacyName;
  final String date;
  final String itemsCount;
  final String price;
  final String status;

  OrderModel({
    required this.id,
    required this.pharmacyName,
    required this.date,
    required this.itemsCount,
    required this.price,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      pharmacyName: json['pharmacy']?['name'] ?? '',
      date: json['created_at'] ?? '',
      itemsCount: "${json['total_quantity']} items",
      price: "\$${json['final_total']}",
      status: (json['status'] ?? '').toString().toUpperCase(),
    );
  }
}