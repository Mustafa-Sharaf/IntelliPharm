

class PharmacyModel {
  final int id;
  final String name;
  final String region;
  final String latitude;
  final String longitude;
  final String openingTime;
  final String closingTime;

  PharmacyModel({
    required this.id,
    required this.name,
    required this.region,
    required this.latitude,
    required this.longitude,
    required this.openingTime,
    required this.closingTime,
  });

  factory PharmacyModel.fromJson(Map<String, dynamic> json) {
    return PharmacyModel(
      id: json['id'],
      name: json['name'] ?? '',
      region: json['region'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      openingTime: json['opening_time'] ?? '',
      closingTime: json['closing_time'] ?? '',
    );
  }
}