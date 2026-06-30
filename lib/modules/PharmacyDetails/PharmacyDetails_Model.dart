class PharmacyDetailsModel {
  final int id;
  final String nameAr;
  final String nameEn;
  final int regionId;
  final String region;
  final double latitude;
  final double longitude;
  final String openingTime;
  final String closingTime;
  final bool isActive;
  final String pharmacistName;
  final String pharmacistPhone;
  final String? pharmacistAltPhone;
  final List<HistoryNote> historyNotes;
  final List<String>? holidays;
  final bool isOpen;

  PharmacyDetailsModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.regionId,
    required this.region,
    required this.latitude,
    required this.longitude,
    required this.openingTime,
    required this.closingTime,
    required this.isActive,
    required this.pharmacistName,
    required this.pharmacistPhone,
    this.pharmacistAltPhone,
    required this.historyNotes,
    this.holidays,
    required this.isOpen,
  });

  factory PharmacyDetailsModel.fromJson(Map<String, dynamic> json) {
    String parsedNameAr = '';
    String parsedNameEn = '';
    if (json['name'] != null) {
      if (json['name'] is Map) {
        parsedNameAr = json['name']['ar'] ?? '';
        parsedNameEn = json['name']['en'] ?? '';
      } else if (json['name'] is String) {
        parsedNameAr = json['name'];
        parsedNameEn = json['name'];
      }
    }

    double parseCoordinate(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return PharmacyDetailsModel(
      id: json['id'] ?? 0,
      nameAr: parsedNameAr,
      nameEn: parsedNameEn,
      regionId: json['region_id'] ?? 0,
      region: json['region'] ?? '',
      latitude: parseCoordinate(json['latitude']),
      longitude: parseCoordinate(json['longitude']),
      openingTime: json['opening_time'] ?? '',
      closingTime: json['closing_time'] ?? '',
      isActive: json['is_active'] == 1,
      pharmacistName: json['pharmacist_name'] ?? '',
      pharmacistPhone: json['pharmacist_phone'] ?? '',
      pharmacistAltPhone: json['pharmacist_alt_phone'],

      historyNotes: json['history_notes'] != null && json['history_notes'] is List
          ? List<HistoryNote>.from(
        (json['history_notes'] as List)
            .whereType<Map>()
            .map((x) => HistoryNote.fromJson(x as Map<String, dynamic>)),
      )
          : [],

      holidays: json['holidays'] != null && json['holidays'] is List
          ? List<String>.from(json['holidays'])
          : null,
      isOpen: json['is_open'] ?? false,
    );
  }
}

class HistoryNote {
  final int id;
  final String content;
  final String noteType;
  final String authorName;
  final String createdAt;

  HistoryNote({
    required this.id,
    required this.content,
    required this.noteType,
    required this.authorName,
    required this.createdAt,
  });

  factory HistoryNote.fromJson(Map<String, dynamic> json) {
    String rawDate = json['visited_at'] ?? '';
    if (rawDate.isEmpty) {
      rawDate = DateTime.now().toString().split('.').first;
    }

    return HistoryNote(
      id: json['id'] ?? 0,
      content: json['notes'] ?? '',
      noteType: json['note_type'] ?? 'general',
      authorName: json['user_name'] ?? 'Admin',
      createdAt: rawDate,
    );
  }
}