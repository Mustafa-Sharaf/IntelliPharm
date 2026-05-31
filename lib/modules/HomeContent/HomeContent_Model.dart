class HomePageModel {
  final StatisticsModel statistics;
  final List<TodayVisitModel> todayVisits;

  HomePageModel({
    required this.statistics,
    required this.todayVisits,
  });

  factory HomePageModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return HomePageModel(
      statistics: StatisticsModel.fromJson(data['statistics']),
      todayVisits: (data['today_visits'] as List)
          .map((e) => TodayVisitModel.fromJson(e))
          .toList(),
    );
  }
}

class StatisticsModel {
  final int visitsCount;
  final int usefulVisitsCount;
  final int ordersCount;

  StatisticsModel({
    required this.visitsCount,
    required this.usefulVisitsCount,
    required this.ordersCount,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      visitsCount: json['visits_count'] ?? 0,
      usefulVisitsCount: json['useful_visits_count'] ?? 0,
      ordersCount: json['orders_count'] ?? 0,
    );
  }
}

class TodayVisitModel {
  final int id;
  final int pharmacyId;
  final String pharmacyName;
  final bool visited;
  final bool useful;
  final int visitOrder;
  final String createdAt;
  final int planId;
  final String planName;
  final int regionId;

  TodayVisitModel({
    required this.id,
    required this.pharmacyId,
    required this.pharmacyName,
    required this.visited,
    required this.useful,
    required this.visitOrder,
    required this.createdAt,
    required this.planId,
    required this.planName,
    required this.regionId,
  });

  factory TodayVisitModel.fromJson(Map<String, dynamic> json) {
    return TodayVisitModel(
      id: json['id'],
      pharmacyId: json['pharmacy_id'],
      pharmacyName: json['pharmacy_name'] ?? '',
      visited: json['visited'] ?? false,
      useful: json['useful'] ?? false,
      visitOrder: json['visit_order'] ?? 0,
      createdAt: json['created_at'] ?? '',
      planId: json['plan_id'] ?? 0,
      planName: json['plan_name'] ?? '',
      regionId: json['region_id'] ?? 0,
    );
  }
}