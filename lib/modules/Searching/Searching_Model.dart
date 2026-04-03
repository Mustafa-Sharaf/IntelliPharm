
class Medicine {
  final int id;
  final String name;
  final double price;
  final int quantity;
  final bool isImported;

  Medicine({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.isImported,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json["id"],
      name: json["name"],
      price: double.parse(json["price"]),
      quantity: json["available_quantity"],
      isImported: json["is_imported"],
    );
  }
}