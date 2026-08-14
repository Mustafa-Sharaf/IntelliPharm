class MedicineDetailsResponse {
  final bool isSuccess;
  final String message;
  final MedicineDetailsData? data;

  MedicineDetailsResponse({
    required this.isSuccess,
    required this.message,
    this.data,
  });

  factory MedicineDetailsResponse.fromJson(dynamic json) {
    // التعامل مع الحالات التي يكون فيها الـ json نص أو Map
    if (json is! Map<String, dynamic>) {
      return MedicineDetailsResponse(isSuccess: false, message: 'Invalid Format');
    }
    return MedicineDetailsResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? MedicineDetailsData.fromJson(json['data'])
          : null,
    );
  }
}

class MedicineDetailsData {
  final int id;
  final LocalizedName commercialName;
  final String scientificName;
  final double price;
  final int availableQuantity;
  final GiftInfo? gift;
  final bool isImported;
  final bool isActive;
  final bool inStock;
  final String barcode;
  final List<String> images;
  final CategoryInfo? category;
  final LaboratoryInfo? laboratory;
  final List<AlternativeMedicine> alternatives;

  MedicineDetailsData({
    required this.id,
    required this.commercialName,
    required this.scientificName,
    required this.price,
    required this.availableQuantity,
    this.gift,
    required this.isImported,
    required this.isActive,
    required this.inStock,
    required this.barcode,
    required this.images,
    this.category,
    this.laboratory,
    required this.alternatives,
  });

  factory MedicineDetailsData.fromJson(Map<String, dynamic> json) {
    return MedicineDetailsData(
      id: json['id'] ?? 0,
      commercialName: LocalizedName.fromJson(json['commercial_name']),
      scientificName: json['scientific_name'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      availableQuantity: json['available_quantity'] ?? 0,
      gift: json['gift'] is Map<String, dynamic>
          ? GiftInfo.fromJson(json['gift'])
          : null,
      isImported: json['is_imported'] ?? false,
      isActive: json['is_active'] ?? false,
      inStock: json['in_stock'] ?? false,
      barcode: json['barcode'] ?? '',
      images: (json['images'] as List? ?? []).map((e) => e.toString()).toList(),
      category: json['category'] is Map<String, dynamic>
          ? CategoryInfo.fromJson(json['category'])
          : null,
      laboratory: json['laboratory'] is Map<String, dynamic>
          ? LaboratoryInfo.fromJson(json['laboratory'])
          : null,
      alternatives: (json['alternatives'] as List? ?? [])
          .whereType<Map<String, dynamic>>() // 👈 يضمن عدم حصول كراش إذا كان العنصر ليس Map
          .map((e) => AlternativeMedicine.fromJson(e))
          .toList(),
    );
  }
}

class LocalizedName {
  final String ar;
  final String en;

  LocalizedName({required this.ar, required this.en});

  factory LocalizedName.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return LocalizedName(
        ar: json['ar']?.toString() ?? '',
        en: json['en']?.toString() ?? '',
      );
    } else if (json is String) {
      // احتياطاً لو أرجع السيرفر الاسم كنص عادي بدلاً من Object
      return LocalizedName(ar: json, en: json);
    }
    return LocalizedName(ar: '', en: '');
  }

  String getName(String langCode) => langCode == 'ar' ? ar : en;
}

class GiftInfo {
  final int giftQuantity;
  final int requiredQuantity;

  GiftInfo({required this.giftQuantity, required this.requiredQuantity});

  factory GiftInfo.fromJson(Map<String, dynamic> json) {
    return GiftInfo(
      giftQuantity: json['gift_quantity'] ?? 0,
      requiredQuantity: json['required_quantity'] ?? 0,
    );
  }
}

class CategoryInfo {
  final int id;
  final String name;

  CategoryInfo({required this.id, required this.name});

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }
}

class LaboratoryInfo {
  final int id;
  final String name;

  LaboratoryInfo({required this.id, required this.name});

  factory LaboratoryInfo.fromJson(Map<String, dynamic> json) {
    return LaboratoryInfo(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }
}

class AlternativeMedicine {
  final int id;
  final LocalizedName commercialName;
  final double price;
  final bool isImported;
  final bool isActive;
  final String note;
  final List<String> images;

  AlternativeMedicine({
    required this.id,
    required this.commercialName,
    required this.price,
    required this.isImported,
    required this.isActive,
    required this.note,
    required this.images,
  });

  factory AlternativeMedicine.fromJson(Map<String, dynamic> json) {
    return AlternativeMedicine(
      id: json['id'] ?? 0,
      commercialName: LocalizedName.fromJson(json['commercial_name']),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      isImported: json['is_imported'] ?? false,
      isActive: json['is_active'] ?? false,
      note: json['note']?.toString() ?? '',
      images: (json['images'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }
}