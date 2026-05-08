
class MedicineModel {
  final int id;
  final int categoryId;
  final String commercialName;
  final String scientificName;
  final double price;
  final bool isImported;
  final int availableQuantity;
  final String barcode;

  MedicineModel({
    required this.id,
    required this.categoryId,
    required this.commercialName,
    required this.scientificName,
    required this.price,
    required this.isImported,
    required this.availableQuantity,
    required this.barcode,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'],
      categoryId: json['category_id'],
      commercialName: json['commercial_name'] ?? '',
      scientificName: json['scientific_name'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      isImported: json['is_imported'] ?? false,
      availableQuantity: json['available_quantity'] ?? 0,
      barcode: json['barcode'] ?? '',
    );
  }
}