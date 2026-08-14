class ProfileModel {
  final bool isSuccess;
  final String message;
  final ProfileData? data;

  ProfileModel({
    required this.isSuccess,
    required this.message,
    this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
    );
  }
}

class ProfileData {
  final RepUser rep;
  final RepStats stats;
  final List<TargetStat> targetStats;

  ProfileData({
    required this.rep,
    required this.stats,
    required this.targetStats,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      rep: RepUser.fromJson(json['rep'] ?? {}),
      stats: RepStats.fromJson(json['stats'] ?? {}),
      targetStats: (json['targetStats'] as List? ?? [])
          .map((e) => TargetStat.fromJson(e))
          .toList(),
    );
  }
}

class RepUser {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String role;
  //final String region;

  RepUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    //this.region = 'NORTH REGION',
  });

  factory RepUser.fromJson(Map<String, dynamic> json) {
    return RepUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      role: json['role'] ?? '',
     // region: json['region'] ?? 'NORTH REGION',
    );
  }
}

class RepStats {
  final int activeClients;
  final int ordersThisMonth;
  final double avgDealSize;

  RepStats({
    required this.activeClients,
    required this.ordersThisMonth,
    required this.avgDealSize,
  });

  factory RepStats.fromJson(Map<String, dynamic> json) {
    return RepStats(
      activeClients: json['active_clients'] ?? 0,
      ordersThisMonth: json['orders_this_month'] ?? 0,
      avgDealSize: (json['avg_deal_size'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class TargetStat {
  final String targetName;
  final String targetType;
  final String representativeName;
  final double achievedValue;
  final double targetValue;

  TargetStat({
    required this.targetName,
    required this.targetType,
    required this.representativeName,
    required this.achievedValue,
    required this.targetValue,
  });

  factory TargetStat.fromJson(Map<String, dynamic> json) {
    return TargetStat(
      targetName: json['target_name'] ?? '',
      targetType: json['target_type'] ?? '',
      representativeName: json['representative_name'] ?? '',
      achievedValue: double.tryParse(json['achieved_value']?.toString() ?? '0') ?? 0.0,
      targetValue: double.tryParse(json['target_value']?.toString() ?? '0') ?? 0.0,
    );
  }

  double get progressPercentage {
    if (targetValue <= 0) return 0.0;
    final ratio = achievedValue / targetValue;
    return ratio > 1.0 ? 1.0 : ratio;
  }
}