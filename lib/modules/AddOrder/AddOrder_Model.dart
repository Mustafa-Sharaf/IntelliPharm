
class MedicineModel {
  final int id;
  final int categoryId;
  final String commercialName;
  final String scientificName;
  final double price;
  final bool isImported;
  final int availableQuantity;
  final String barcode;
  final List<String> images;
  final GiftModel? gift;

  MedicineModel({
    required this.id,
    required this.categoryId,
    required this.commercialName,
    required this.scientificName,
    required this.price,
    required this.isImported,
    required this.availableQuantity,
    required this.barcode,
    required this.images,
    required this.gift,
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
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      gift: json['gift'] != null ? GiftModel.fromJson(json['gift']) : null,
    );
  }
}

class GiftModel {
  final int giftQuantity;
  final int requiredQuantity;

  GiftModel({
    required this.giftQuantity,
    required this.requiredQuantity,
  });

  factory GiftModel.fromJson(Map<String, dynamic> json) {
    return GiftModel(
      giftQuantity: json['gift_quantity'] ?? 0,
      requiredQuantity: json['required_quantity'] ?? 0,
    );
  }
}

