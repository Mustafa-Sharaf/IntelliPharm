
class MedicineModel {
  final int id;
  final int categoryId;
  final String name;
  final double price;
  final bool isImported;
  final bool isActive;
  final int availableQuantity;
  final bool inStock;
  final String barcode;

  MedicineModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.isImported,
    required this.isActive,
    required this.availableQuantity,
    required this.inStock,
    required this.barcode,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      isImported: json['is_imported'] ?? false,
      isActive: json['is_active'] ?? false,
      availableQuantity: json['available_quantity'] ?? 0,
      inStock: json['in_stock'] ?? false,
      barcode: json['barcode'] ?? '',
    );
  }
}