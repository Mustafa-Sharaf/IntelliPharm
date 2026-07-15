import 'ActiveOptimizedRouteTracking_Model.dart';
import 'package:get/get.dart';

class PlanRouteCalculator {
  static String getFormatDistanceForVisit(PlanResponse plan, int index) {
    if (index < 0 || index >= plan.visits.length) return "ZERO_KM".tr;

    double distanceKm = 0.0;
    if (index < plan.paths.length) {
      distanceKm = plan.paths[index].distanceKm;
    }

    return formatDistance(distanceKm);
  }

  static String formattedTotalDistance(PlanResponse plan) {
    return formatDistance(plan.totalDistanceKm);
  }

  static String formattedTotalDuration(PlanResponse plan) {
    double totalMinutes = plan.totalDurationHours * 60;
    int hours = (totalMinutes / 60).floor();
    int minutes = (totalMinutes % 60).round();

    if (hours > 0) {
      return "DURATION_HM".trParams({
        'hours': hours.toString(),
        'minutes': minutes.toString(),
      });
    }
    return "DURATION_M".trParams({'minutes': minutes.toString()});
  }

  static String getETAForVisit(PlanResponse plan, int index) {
    if (index < 0 || index >= plan.visits.length) return "--:--";

    DateTime startTime;
    try {
      startTime = DateTime.parse(plan.createdAt).toLocal();
    } catch (_) {
      startTime = DateTime.now();
    }

    double accumulatedHours = 0.0;
    for (int i = 0; i <= index; i++) {
      if (i < plan.paths.length) {
        accumulatedHours += plan.paths[i].durationHours;
      }
    }

    DateTime etaTime = startTime.add(
      Duration(seconds: (accumulatedHours * 3600).round()),
    );

    int hour = etaTime.hour;
    int minute = etaTime.minute;
    String period = hour >= 12 ? "PM".tr : "AM".tr;
    hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    String minuteStr = minute < 10 ? "0$minute" : "$minute";

    return "$hour:$minuteStr $period";
  }

  static String formatDistance(double distance) {
    if (distance < 1.0) {
      int meters = (distance * 1000).round();
      return "DISTANCE_M".trParams({'meters': meters.toString()});
    }
    return "DISTANCE_KM".trParams({'distance': distance.toStringAsFixed(1)});
  }
}
