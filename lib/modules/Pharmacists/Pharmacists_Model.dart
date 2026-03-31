

class PharmaciesModel {
  final int id;
  final String name;
  final String region;
  final String openingTime;
  final String closingTime;
  final String? pharmacistName;
  final String pharmacistPhone;

  PharmaciesModel({
    required this.id,
    required this.name,
    required this.region,
    required this.openingTime,
    required this.closingTime,
    this.pharmacistName,
    required this.pharmacistPhone,
  });

  factory PharmaciesModel.fromJson(Map<String, dynamic> json) {
    return PharmaciesModel(
      id: json['id'],
      name: json['name'] ?? "",
      region: json['region'] ?? "",
      openingTime: json['opening_time'] ?? "",
      closingTime: json['closing_time'] ?? "",
      pharmacistName: json['pharmacist_name'],
      pharmacistPhone: json['pharmacist_phone'] ?? "",
    );
  }
}