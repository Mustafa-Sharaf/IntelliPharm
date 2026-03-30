class PharmacyModel {
  final int regionId;
  final String name;
  final double latitude;
  final double longitude;
  final String openingTime;
  final String closingTime;
  final bool isActive;
  final String pharmacistName;
  final String pharmacistPhone;
  final String? pharmacistAlt;

  PharmacyModel({
    required this.regionId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.openingTime,
    required this.closingTime,
    required this.isActive,
    required this.pharmacistName,
    required this.pharmacistPhone,
    this.pharmacistAlt,
  });

  Map<String, dynamic> toJson() {
    return {
      "region_id": regionId,
      "name": name,
      "latitude": latitude,
      "longitude": longitude,
      "opening_time": openingTime,
      "closing_time": closingTime,
      "is_active": isActive,
      "pharmacist_name": pharmacistName,
      "pharmacist_phone": pharmacistPhone,
      "pharmacist_alt": pharmacistAlt,
    };
  }
}