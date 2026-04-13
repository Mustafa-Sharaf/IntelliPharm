/*

class PharmacyModel {
  final String name;
  final int regionId;
  final double latitude;
  final double longitude;
  final String openingTime;
  final String closingTime;
  final bool isActive;
  final String pharmacistName;
  final String pharmacistPhone;
  final String? pharmacistAltPhone;

  PharmacyModel({
    required this.name,
    required this.regionId,
    required this.latitude,
    required this.longitude,
    required this.openingTime,
    required this.closingTime,
    required this.isActive,
    required this.pharmacistName,
    required this.pharmacistPhone,
    this.pharmacistAltPhone,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "region_id": regionId,
      "latitude": latitude,
      "longitude": longitude,
      "opening_time": openingTime,
      "closing_time": closingTime,
      "is_active": isActive,
      "pharmacist_name": pharmacistName,
      "pharmacist_phone": pharmacistPhone,
      "pharmacist_alt_phone": pharmacistAltPhone,
    };
  }
}*/
/*
class PharmacyModel {
  final String nameEn;
  final String nameAr;
  final int regionId;
  final double latitude;
  final double longitude;
  final String openingTime;
  final String closingTime;
  final bool isActive;
  final String pharmacistName;
  final String pharmacistPhone;
  final String? pharmacistAltPhone;

  PharmacyModel({
    required this.nameEn,
    required this.nameAr,
    required this.regionId,
    required this.latitude,
    required this.longitude,
    required this.openingTime,
    required this.closingTime,
    required this.isActive,
    required this.pharmacistName,
    required this.pharmacistPhone,
    this.pharmacistAltPhone,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": {
        "en": nameEn,
        "ar": nameAr,
      },
      "region_id": regionId,
      "latitude": latitude,
      "longitude": longitude,
      "opening_time": openingTime,
      "closing_time": closingTime,
      "is_active": isActive,
      "pharmacist_name": pharmacistName,
      "pharmacist_phone": pharmacistPhone,
      "pharmacist_alt_phone": pharmacistAltPhone,
    };
  }
}*/
