

import '../AddOrder/AddOrder_Model.dart';

class MedicineDetailsModel {
  final int id;
  final String scientificName;
  final List<MedicineModel> alternatives;

  MedicineDetailsModel({
    required this.id,
    required this.scientificName,
    required this.alternatives,
  });

  factory MedicineDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final scientificName = data['scientific_name'] ?? '';
    final List altList = data['alternatives'] ?? [];

    List<MedicineModel> parsedAlternatives = altList.map((e) {
      String commName = '';
      if (e['commercial_name'] is Map) {
        commName = e['commercial_name']['ar'] ?? e['commercial_name']['en'] ?? '';
      } else {
        commName = e['commercial_name']?.toString() ?? '';
      }

      return MedicineModel(
        id: e['id'],
        categoryId: e['category_id'] ?? 0,
        commercialName: commName,
        scientificName: scientificName,
        price: double.tryParse(e['price'].toString()) ?? 0.0,
        isImported: e['is_imported'] ?? false,
        availableQuantity: e['available_quantity'] ?? 0,
        barcode: '',
        images: (e['images'] as List?)?.map((x) => x.toString()).toList() ?? [],
        gift: null,
      );
    }).toList();

    return MedicineDetailsModel(
      id: data['id'] ?? 0,
      scientificName: scientificName,
      alternatives: parsedAlternatives,
    );
  }
}