import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapHelperController extends GetxController {
  var latitude = 33.5138.obs;
  var longitude = 36.2765.obs;
  final mapController = Rxn<GoogleMapController>();
  var markers = <Marker>{}.obs;
  var polyLines = <Polyline>{}.obs;
  var mapStyleString = RxnString(null);

  BitmapDescriptor? customCarIcon;
  Timer? _animTimer;
  LatLng? _currentAnimatedPosition;
  double _currentHeading = 0.0;

  Future<BitmapDescriptor> getBitmapDescriptorFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    final Uint8List resizedBytes = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    return BitmapDescriptor.bytes(resizedBytes);
  }

  void setMapController(GoogleMapController controller) {
    mapController.value = controller;
    applyMapStyle();
  }
  void clearMapController() {
    mapController.value = null;
  }

  Future<void> loadCustomMarkerIcon() async {
    try {
      customCarIcon = await getBitmapDescriptorFromAsset('assets/images/DeliveryBicycle.png', 40);
    } catch (e) {
      print("Error loading custom marker icon: $e");
    }
  }

  Future<void> setDarkMapStyle() async {
    try {
      final style = await rootBundle.loadString('assets/map_dark.json');
      mapStyleString.value = style;
    } catch (e) {
      print("The dark map theme could not be applied: $e");
    }
  }

  void applyMapStyle() {
    if (Get.isDarkMode) {
      setDarkMapStyle();
    } else {
      mapStyleString.value = null;
    }
  }

  @override
  void onInit() {
    super.onInit();

    _initializeMap();

    ever(Get.isDarkMode.obs, (isDark) {
      applyMapStyle();
    });
  }

  Future<void> _initializeMap() async {
    await loadCustomMarkerIcon();
    try {
      await moveToCurrentLocation();
    } catch (e) {
      print("Location init error: $e");
    }
  }


  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("GPS_DISABLED");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("PERMISSION_DENIED");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("PERMISSION_DENIED_FOREVER");
    }

    try {
      // محاولة جلب آخر موقع معروف فوراً دون انتظار GPS
      Position? lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        return lastPosition;
      }

      // في حال عدم وجود موقع سابق، نطلب الموقع الحالي بمهلة قصيرة جداً (3 ثوانٍ)
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium, // تقليل الدقة لتسريع الاستجابة
        ),
      ).timeout(const Duration(seconds: 3));
    } catch (e) {
      //print("❌ تعذر جلب الموقع الفعلي، استخدام الموقع الافتراضي: $e");
      //  إرجاع موقع افتراضي لمنع تعليق التطبيق نهائياً
      return Position(
        latitude: latitude.value,
        longitude: longitude.value,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }
  }

  Future<void> moveToCurrentLocation() async {
    try {
      final position = await getCurrentLocation();
      await setLocation(position.latitude, position.longitude);
    } catch (e) {
      print("Error while fetching current location: $e");
      rethrow;
    }
  }


  Future<void> setLocation(
      double lat,
      double lng, {
        bool moveCamera = true,
      }) async {
    latitude.value = lat;
    longitude.value = lng;

    final pos = LatLng(lat, lng);
    _currentAnimatedPosition = pos;
    _addOrUpdateMarker(pos, 0.0);

    if (moveCamera && mapController.value != null) {
      try {
        await mapController.value!.animateCamera(
          CameraUpdate.newLatLngZoom(pos, 15),
        );
      } catch (e) {
        print("Camera move error: $e");
      }
    }
  }

  /// تحديث موقع المندوب المباشر مع حركة أنيميشن انسيابية كلياً
  Future<void> updateMyLocation({
    required double latitude,
    required double longitude,
    double? heading,
    bool moveCamera = true,
  }) async {
    final targetLocation = LatLng(latitude, longitude);
    this.latitude.value = latitude;
    this.longitude.value = longitude;

    // إذا كانت أول نقطة يتم تحديدها
    if (_currentAnimatedPosition == null) {
      _currentAnimatedPosition = targetLocation;
      _currentHeading = heading ?? 0.0;
      _addOrUpdateMarker(targetLocation, _currentHeading);
    } else {
      // الانطلاق دائماً من النقطة الحالية للأنيميشن لمنع القفز
      _animateMarkerSmoothly(
        start: _currentAnimatedPosition!,
        end: targetLocation,
        newHeading: heading,
        moveCamera: moveCamera,
      );
    }
  }

  /// تحريك الماركر بنعومة بالغة وحساب أقصر زاوية دوران
  void _animateMarkerSmoothly({
    required LatLng start,
    required LatLng end,
    double? newHeading,
    bool moveCamera = true,
  }) {
    _animTimer?.cancel();

    const steps = 25;
    const duration = Duration(milliseconds: 600);
    final stepDuration = Duration(milliseconds: duration.inMilliseconds ~/ steps);

    final double startHeading = _currentHeading;
    final double targetHeading = newHeading ?? startHeading;

    // حساب أقصر مسار لتدوير الزاوية لمنع الشقلبة المفاجئة
    double diffHeading = (targetHeading - startHeading) % 360;
    if (diffHeading > 180) diffHeading -= 360;
    if (diffHeading < -180) diffHeading += 360;

    int currentStep = 0;
    _animTimer = Timer.periodic(stepDuration, (timer) {
      currentStep++;
      final double fraction = currentStep / steps;

      // حساب الموقع الجديد تدريجياً
      final lat = start.latitude + (end.latitude - start.latitude) * fraction;
      final lng = start.longitude + (end.longitude - start.longitude) * fraction;
      _currentAnimatedPosition = LatLng(lat, lng);

      // حساب الزاوية تدريجياً
      _currentHeading = startHeading + (diffHeading * fraction);

      _addOrUpdateMarker(_currentAnimatedPosition!, _currentHeading);

      // تحريك الكاميرا مع الماركر بسلاسة
      if (moveCamera && mapController.value != null && currentStep % 2 == 0) {
        try {
          mapController.value!.moveCamera(
            CameraUpdate.newLatLng(_currentAnimatedPosition!),
          );
        } catch (e) {
          print("Camera track error: $e");
        }
      }

      if (currentStep >= steps) {
        timer.cancel();
      }
    });
  }

  /// رسم أو تحديث الماركر في القائمة
  void _addOrUpdateMarker(LatLng position, double heading) {
    markers.removeWhere((m) => m.markerId.value == 'current_location');
    markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: position,
        flat: true, // تجعل الصورة تلتصق بسطح الخريطة أثناء التدوير
        rotation: ((heading + 90.0) % 360), // إضافة 90 درجة لتعديل جهة الصورة
        anchor: const Offset(0.5, 0.5),
        //zIndex: 10,
        zIndexInt: 10,
        icon: customCarIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
  }

  void moveCameraToBounds(List<LatLng> points) {
    if (points.isEmpty || mapController.value == null) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    try {
      mapController.value!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    } catch (e) {
      print("The camera could not be moved to the border: $e");
    }
  }

  // =========================
  // Markers & PolyLines
  // =========================

  void addPolyline(List<LatLng> points) {
    final polyline = Polyline(
      polylineId: PolylineId("${DateTime.now()}_${points.length}"),
      color: const Color(0xFF2196F3),
      width: 5,
      points: points,
    );
    polyLines.add(polyline);
  }

  void drawRoutes(List<List<LatLng>> allPaths) {
    polyLines.clear();
    for (var path in allPaths) {
      addPolyline(path);
    }
    moveCameraToBounds(allPaths.expand((e) => e).toList());
  }

  void addPharmacyMarker({required LatLng position, required int order}) {
    markers.add(
      Marker(
        markerId: MarkerId('pharmacy_$order'),
        position: position,
        infoWindow: InfoWindow(title: "pharmacy $order"),
      ),
    );
  }

  void addMarker({
    required LatLng position,
    required String title,
    BitmapDescriptor? icon,
  }) {
    markers.add(
      Marker(
        markerId: MarkerId(title),
        position: position,
        icon: icon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(title: title),
      ),
    );
  }

  void clearAll() {
    markers.clear();
    polyLines.clear();
  }

  @override
  void onClose() {
    _animTimer?.cancel();
    super.onClose();
  }
}
/*
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapHelperController extends GetxController {
  var latitude = 33.5138.obs;
  var longitude = 36.2765.obs;
  final mapController = Rxn<GoogleMapController>();
  var markers = <Marker>{}.obs;
  var polyLines = <Polyline>{}.obs;
  var mapStyleString = RxnString(null);

  /// 🟢 خاصية للتحكم بتفعيل/تعطيل تحريك الأيقونة كـ (سيكل ومتحرك) في الشاشات العادية
  bool isTrackingDriver = false;

  BitmapDescriptor? customCarIcon;
  Timer? _animTimer;
  LatLng? _currentAnimatedPosition;
  double _currentHeading = 0.0;

  Future<BitmapDescriptor> getBitmapDescriptorFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    final Uint8List resizedBytes = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    return BitmapDescriptor.bytes(resizedBytes);
  }

  void setMapController(GoogleMapController controller) {
    mapController.value = controller;
    applyMapStyle();
  }

  void clearMapController() {
    mapController.value = null;
  }

  Future<void> loadCustomMarkerIcon() async {
    try {
      customCarIcon = await getBitmapDescriptorFromAsset('assets/images/DeliveryBicycle.png', 40);
    } catch (e) {
      print("Error loading custom marker icon: $e");
    }
  }

  Future<void> setDarkMapStyle() async {
    try {
      final style = await rootBundle.loadString('assets/map_dark.json');
      mapStyleString.value = style;
    } catch (e) {
      print("The dark map theme could not be applied: $e");
    }
  }

  void applyMapStyle() {
    if (Get.isDarkMode) {
      setDarkMapStyle();
    } else {
      mapStyleString.value = null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _initializeMap();
    ever(Get.isDarkMode.obs, (isDark) {
      applyMapStyle();
    });
  }

  Future<void> _initializeMap() async {
    await loadCustomMarkerIcon();
    try {
      await moveToCurrentLocation();
    } catch (e) {
      print("Location init error: $e");
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("GPS_DISABLED");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("PERMISSION_DENIED");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("PERMISSION_DENIED_FOREVER");
    }

    try {
      Position? lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        return lastPosition;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      ).timeout(const Duration(seconds: 3));
    } catch (e) {
      return Position(
        latitude: latitude.value,
        longitude: longitude.value,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }
  }

  Future<void> moveToCurrentLocation() async {
    try {
      final position = await getCurrentLocation();
      await setLocation(position.latitude, position.longitude);
    } catch (e) {
      print("Error while fetching current location: $e");
    }
  }

  Future<void> setLocation(
      double lat,
      double lng, {
        bool moveCamera = true,
      }) async {
    latitude.value = lat;
    longitude.value = lng;

    final pos = LatLng(lat, lng);
    _currentAnimatedPosition = pos;
    _addOrUpdateMarker(pos, 0.0);

    if (moveCamera && mapController.value != null) {
      try {
        await mapController.value!.animateCamera(
          CameraUpdate.newLatLngZoom(pos, 15),
        );
      } catch (e) {
        print("Camera move error: $e");
      }
    }
  }

  Future<void> updateMyLocation({
    required double latitude,
    required double longitude,
    double? heading,
    bool moveCamera = true,
  }) async {
    final targetLocation = LatLng(latitude, longitude);
    this.latitude.value = latitude;
    this.longitude.value = longitude;

    if (_currentAnimatedPosition == null) {
      _currentAnimatedPosition = targetLocation;
      _currentHeading = heading ?? 0.0;
      _addOrUpdateMarker(targetLocation, _currentHeading);
    } else {
      _animateMarkerSmoothly(
        start: _currentAnimatedPosition!,
        end: targetLocation,
        newHeading: heading,
        moveCamera: moveCamera,
      );
    }
  }

  void _animateMarkerSmoothly({
    required LatLng start,
    required LatLng end,
    double? newHeading,
    bool moveCamera = true,
  }) {
    _animTimer?.cancel();

    const steps = 25;
    const duration = Duration(milliseconds: 600);
    final stepDuration = Duration(milliseconds: duration.inMilliseconds ~/ steps);

    final double startHeading = _currentHeading;
    final double targetHeading = newHeading ?? startHeading;

    double diffHeading = (targetHeading - startHeading) % 360;
    if (diffHeading > 180) diffHeading -= 360;
    if (diffHeading < -180) diffHeading += 360;

    int currentStep = 0;
    _animTimer = Timer.periodic(stepDuration, (timer) {
      currentStep++;
      final double fraction = currentStep / steps;

      final lat = start.latitude + (end.latitude - start.latitude) * fraction;
      final lng = start.longitude + (end.longitude - start.longitude) * fraction;
      _currentAnimatedPosition = LatLng(lat, lng);

      _currentHeading = startHeading + (diffHeading * fraction);

      _addOrUpdateMarker(_currentAnimatedPosition!, _currentHeading);

      if (moveCamera && mapController.value != null && currentStep % 2 == 0) {
        try {
          mapController.value!.moveCamera(
            CameraUpdate.newLatLng(_currentAnimatedPosition!),
          );
        } catch (e) {
          print("Camera track error: $e");
        }
      }

      if (currentStep >= steps) {
        timer.cancel();
      }
    });
  }

  /// 🟢 تحديث رسم الماركر حسب حالة `isTrackingDriver`
  void _addOrUpdateMarker(LatLng position, double heading) {
    markers.removeWhere((m) => m.markerId.value == 'current_location');

    if (isTrackingDriver) {
      // ماركر التتبع المباشر (دباب السيكل المتحرك المائل)
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: position,
          flat: true,
          rotation: ((heading + 90.0) % 360),
          anchor: const Offset(0.5, 0.5),
          zIndexInt: 10,
          icon: customCarIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    } else {
      // 🟢 ماركر ثابت عادي لجميع الخرائط الأخرى
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: position,
          flat: false,
          rotation: 0.0,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: "موقعي الحالي"),
        ),
      );
    }
  }

  void moveCameraToBounds(List<LatLng> points) {
    if (points.isEmpty || mapController.value == null) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    try {
      mapController.value!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    } catch (e) {
      print("The camera could not be moved to the border: $e");
    }
  }

  /// 🟢 إضافة Polyline بألوان مخصصة
*/
/*  void addPolyline(List<LatLng> points, {Color color = const Color(0xFF2196F3), String? polylineId}) {
    final polyline = Polyline(
      polylineId: PolylineId(polylineId ?? "${DateTime.now()}_${points.length}"),
      color: color,
      width: 5,
      points: points,
    );
    polyLines.add(polyline);
  }*//*

  void addPolyline(
      List<LatLng> points, {
        Color color = const Color(0xFF2196F3),
        String? polylineId,
      }) {
    final polyline = Polyline(
      polylineId: PolylineId(polylineId ?? "${DateTime.now().millisecondsSinceEpoch}_${points.length}"),
      color: color,
      width: 5,
      points: points,
    );
    polyLines.add(polyline);
    polyLines.refresh(); // 🟢 إجبار GetX على إرسال التحديث للخرائط
  }

  void clearAll() {
    markers.clear();
    polyLines.clear();
    markers.refresh();
    polyLines.refresh();
  }
  */
/*  void clearAll() {
    markers.clear();
    polyLines.clear();
  }*//*


  void drawRoutes(List<List<LatLng>> allPaths) {
    polyLines.clear();
    for (var path in allPaths) {
      addPolyline(path);
    }
    moveCameraToBounds(allPaths.expand((e) => e).toList());
  }

  void addMarker({
    required LatLng position,
    required String title,
    BitmapDescriptor? icon,
  }) {
    markers.add(
      Marker(
        markerId: MarkerId(title),
        position: position,
        icon: icon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(title: title),
      ),
    );
  }



  @override
  void onClose() {
    _animTimer?.cancel();
    super.onClose();
  }
}*/
