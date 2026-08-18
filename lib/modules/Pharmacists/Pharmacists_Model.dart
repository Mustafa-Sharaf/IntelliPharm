class PharmaciesModel {
  final int id;
  final String name;
  final int? regionId;
  final String region;
  final String? latitude;
  final String? longitude;
  final String openTime;
  final String closeTime;
  final String? pharmacistName;
  final String pharmacistPhone;
  final String? pharmacistAltPhone;
  final int isActive;
  final bool isOpen;

  PharmaciesModel({
    required this.id,
    required this.name,
    this.regionId,
    required this.region,
    this.latitude,
    this.longitude,
    required this.openTime,
    required this.closeTime,
    this.pharmacistName,
    required this.pharmacistPhone,
    this.pharmacistAltPhone,
    required this.isActive,
    required this.isOpen,
  });

  factory PharmaciesModel.fromJson(Map<String, dynamic> json) {
    return PharmaciesModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "بدون اسم",
      regionId: json['region_id'],
      region: json['region'] ?? "منطقة غير معروفة",
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      openTime: json['opening_time'] ?? "00:00:00",
      closeTime: json['closing_time'] ?? "00:00:00",
      pharmacistName: json['pharmacist_name'],
      pharmacistPhone: json['pharmacist_phone'] ?? "",
      pharmacistAltPhone: json['pharmacist_alt_phone'],
      isActive: json['is_active'] ?? 0,
      isOpen: json['is_open'] ?? false, // استخدام القيمة القادمة من الـ API
    );
  }

  // استخدام قيمة is_open المباشرة القادمة من الـ API بدلاً من الحساب المحلي
  bool get checkIsOpen => isOpen;
}