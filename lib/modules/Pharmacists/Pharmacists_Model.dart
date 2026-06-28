


class PharmaciesModel {
  final int id;
  final String name;
  final String region;
  final String openTime;
  final String closeTime;
  final String? pharmacistName;
  final String pharmacistPhone;
  final int isActive;

  PharmaciesModel({
    required this.id,
    required this.name,
    required this.region,
    required this.openTime,
    required this.closeTime,
    this.pharmacistName,
    required this.pharmacistPhone,
    required this.isActive,
  });

  factory PharmaciesModel.fromJson(Map<String, dynamic> json) {
    return PharmaciesModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "بدون اسم",
      region: json['region'] ?? "منطقة غير معروفة",
      openTime: json['opening_time'] ?? "00:00:00",
      closeTime: json['closing_time'] ?? "00:00:00",
      pharmacistName: json['pharmacist_name'],
      pharmacistPhone: json['pharmacist_phone'] ?? "",
      isActive: json['is_active'] ?? 0,
    );
  }

  // دالة ذكية لمعرفة هل الصيدلية مفتوحة الآن أم مغلقة بناءً على الوقت الحالي
  bool get checkIsOpen {
    try {
      final now = DateTime.now();

      // تحويل نصوص الوقت إلى أوبجيكت DateTime للمقارنة الرياضية الدقيقة
      final openParts = openTime.split(':');
      final closeParts = closeTime.split(':');

      final openDateTime = DateTime(now.year, now.month, now.day, int.parse(openParts[0]), int.parse(openParts[1]));
      var closeDateTime = DateTime(now.year, now.month, now.day, int.parse(closeParts[0]), int.parse(closeParts[1]));

      // إذا كان وقت الإغلاق في اليوم التالي (مثلاً تفتح 6 مساءً وتغلق 2 صباحاً)
      if (closeDateTime.isBefore(openDateTime)) {
        closeDateTime = closeDateTime.add(const Duration(days: 1));
      }

      return now.isAfter(openDateTime) && now.isBefore(closeDateTime);
    } catch (e) {
      return isActive == 1; // حل احتياطي في حال حدوث مشكلة بفرمتة الوقت من السيرفر
    }
  }
}