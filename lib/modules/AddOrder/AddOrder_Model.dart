class MedicineModel {
  final int id;
  final int categoryId;
  final String name;
  final double price;
  final bool isImported;
  final bool isActive;
  final int availableQuantity;
  final bool inStock;

  MedicineModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.isImported,
    required this.isActive,
    required this.availableQuantity,
    required this.inStock,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      price: double.parse(json['price']),
      isImported: json['is_imported'],
      isActive: json['is_active'],
      availableQuantity: json['available_quantity'],
      inStock: json['in_stock'],
    );
  }
}