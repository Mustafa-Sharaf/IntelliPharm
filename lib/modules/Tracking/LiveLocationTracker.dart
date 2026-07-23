import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../services/ServiceApi/TrackingService.dart';
import '../PlanYourRoute/PlanYourRoute_Controller.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import 'TrackingPingRequest.dart';

class LiveLocationTracker extends GetxService {
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _heartbeatTimer;
  DateTime? _lastPingTime;
  Position? _lastSentPosition;

  static const int minSecondsBetweenPings = 5; // 5 ثوانٍ
  static const double minDistanceFilterMeters = 10.0; // 10 أمتار
  static const int heartbeatIntervalSeconds = 30; // 30 ثانية لسكون المندوب

  Future<void> startTracking() async {
    // 1. صلاحيات الموقع
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    // 2. إعدادات الحساس: نعطي الـ UI أسرع استجابة (مترين) بدون فرملة
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 2, // تحديث مستمر لتنعيم حركة الموتور
    );

    // 3. الاستماع لبث الـ GPS
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _processLocationUpdate(position);
    });

    _startHeartbeatTimer();
  }

  void _processLocationUpdate(Position position) {
    // ==========================================
    // 🟢 1. الـ UI: تحديث سلس ومباشر للموتور (بدون شروط)
    // ==========================================
    final mapController = Get.find<MapHelperController>(tag: "route");
    mapController.updateMyLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      heading: position.heading,
      moveCamera: true,
    );

    // ==========================================
    // 🔵 2. الـ Backend: منطق الـ Hybrid الصحيح
    // ==========================================
    final now = DateTime.now();

    // أول نقطة تُرسل فوراً
    if (_lastSentPosition == null || _lastPingTime == null) {
      _sendLocationToBackendOnly(position);
      _lastPingTime = now;
      _lastSentPosition = position;
      return;
    }

    final int secondsPassed = now.difference(_lastPingTime!).inSeconds;
    final double distanceMoved = Geolocator.distanceBetween(
      _lastSentPosition!.latitude,
      _lastSentPosition!.longitude,
      position.latitude,
      position.longitude,
    );

    // 🔴 الشرط الصحيح والمعكوس:
    // 1. إذا مرت 5 ثوانٍ وكان في حركة تحرّكها المندوب (حالة السرعة/الأوتوستراد لتكثيف وضبط الطلبات)
    // 2. أو إذا قطع 10 أمتار كاملة (حالة البطء/الزحمة لضمان قطع مسافة حقيقية)
    final bool timeCondition = (secondsPassed >= minSecondsBetweenPings) && (distanceMoved >= 2.0);
    final bool distanceCondition = (distanceMoved >= minDistanceFilterMeters);

    if (timeCondition || distanceCondition) {
      _sendLocationToBackendOnly(position);
      _lastPingTime = now;
      _lastSentPosition = position;
    }
  }

  /// إرسال الطلب للباك إند فقط
  Future<void> _sendLocationToBackendOnly(Position position) async {
    final planController = Get.find<PlanYourRouteController>();
    final int regionId = planController.selectedRegion.value?.id ?? 0;
    final int taskId = planController.plan.value?.id ?? 0;

    final request = TrackingPingRequest(
      lat: position.latitude,
      lon: position.longitude,
      heading: position.heading,
      speed: position.speed,
      regionId: regionId,
      taskId: taskId,
    );

    TrackingService.sendPing(request);
  }

  /// Heartbeat عند الوقوف التام بداخل إشارة أو زحمة
  void _startHeartbeatTimer() {
    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: heartbeatIntervalSeconds),
          (_) async {
        if (_lastSentPosition != null && _lastPingTime != null) {
          final now = DateTime.now();
          if (now.difference(_lastPingTime!).inSeconds >= heartbeatIntervalSeconds) {
            _sendLocationToBackendOnly(_lastSentPosition!);
            _lastPingTime = now;
          }
        }
      },
    );
  }

  void stopTracking() {
    _positionStreamSubscription?.cancel();
    _heartbeatTimer?.cancel();
    _positionStreamSubscription = null;
    _heartbeatTimer = null;
  }

  @override
  void onClose() {
    stopTracking();
    super.onClose();
  }
}