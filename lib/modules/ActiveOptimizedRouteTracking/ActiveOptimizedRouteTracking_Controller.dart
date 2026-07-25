/*
import 'package:get/get.dart';
import '../../modules/ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Model.dart';
import '../PlanYourRoute/PlanYourRoute_Controller.dart';
import '../Tracking/LiveLocationTracker.dart';

class ActiveOptimizedRouteTrackingController extends GetxController {
  final planYourRouteController = Get.find<PlanYourRouteController>();
  var isLoading = false.obs;
  var selectedRegion = ''.obs;

  PlanResponse? get plan => planYourRouteController.plan.value;
  late final LiveLocationTracker _locationTracker;

  PlanVisit? get nextVisit {
    if (plan == null || plan!.visits.isEmpty) {
      return null;
    }
    try {
      return plan!.visits.firstWhere((v) => !v.visited);
    } catch (_) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // تجهيز وبدء التتبع فور فتح الشاشة
    _locationTracker = Get.put(LiveLocationTracker());
    _locationTracker.startTracking();
  }

  Future<void> refreshTrackingData() async {
    isLoading.value = true;
    await planYourRouteController.fetchCurrentPlan();
    isLoading.value = false;
  }

  @override
  void onClose() {
    // 1. إيقاف البث والمؤقتات
    _locationTracker.stopTracking();
    // 2. حذف كائن التتبع من الـ GetX memory لمنع التكرار عند إعادة فتح الشاشة
    Get.delete<LiveLocationTracker>();
    super.onClose();
  }
}*/
import 'package:get/get.dart';
import '../../modules/ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Model.dart';
import '../PlanYourRoute/PlanYourRoute_Controller.dart';
import '../Tracking/LiveLocationTracker.dart';

class ActiveOptimizedRouteTrackingController extends GetxController {
  // 🟢 استدعاء آمن ومريح عبر Get.find بدون مخاطرة
  PlanYourRouteController get planYourRouteController => Get.find<PlanYourRouteController>();
  LiveLocationTracker get locationTracker => Get.find<LiveLocationTracker>();

  var isLoading = false.obs;
  var selectedRegion = ''.obs;

  PlanResponse? get plan => planYourRouteController.plan.value;

  PlanVisit? get nextVisit {
    if (plan == null || plan!.visits.isEmpty) {
      return null;
    }
    try {
      return plan!.visits.firstWhere((v) => !v.visited);
    } catch (_) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // 🟢 بدء التتبع فور تحضير الـ Binding
    locationTracker.startTracking();
  }

  Future<void> refreshTrackingData() async {
    isLoading.value = true;
    await planYourRouteController.fetchCurrentPlan();
    isLoading.value = false;
  }

  @override
  void onClose() {
    // 1. إيقاف البث والمؤقتات
    locationTracker.stopTracking();
    super.onClose();
  }
}