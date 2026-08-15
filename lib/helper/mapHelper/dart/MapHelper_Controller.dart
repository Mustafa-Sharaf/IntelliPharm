import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapHelperController extends GetxController {
  // المتغيرات التفاعلية للإحداثيات والكاميرا
  var latitude = 33.5138.obs;
  var longitude = 36.2765.obs;
  final mapController = Rxn<GoogleMapController>();
  var markers = <Marker>{}.obs;
  var polyLines = <Polyline>{}.obs;
  var mapStyleString = RxnString(null);

  BitmapDescriptor? customCarIcon;
  Timer? _animTimer;

  // حفظ الموقع الحالي الفعلي للأنيميشن والزاوية
  LatLng? _currentAnimatedPosition;
  double _currentHeading = 0.0;

  /// تحويل الصورة من الـ Asset وإعادة ضبط حجمها لتناسب دقة الشاشة بدون تشويه
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

  /// تحميل أيقونة المركبة المخصصة (DeliveryBicycle) بحجم مثالي وواضح (80 px)
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

    // 1. تهيئة الخريطة: تحميل الأيقونة أولاً ثم تحديد الموقع الابتدائي
    _initializeMap();

    // 2. الاستماع لتغيرات الثيم المباشرة
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

  // =========================
  // Location & Camera Control
  // =========================

  Future<Position> getCurrentLocation() async {
    // 1️⃣ التأكد من تفعيل خدمة الـ GPS في الهاتف
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("GPS_DISABLED");
    }

    // 2️⃣ التحقق من الصلاحيات وطلبها
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

    // 3️⃣ إعدادات جلب الموقع المباشر (دقة عالية بدون اعتماد على مواقع قديمة)
    final LocationSettings locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      forceLocationManager: false,
    );

    try {
      // نطلب الموقع المباشر مع مهلة 12 ثانية لتجنب تعليق الواجهة
      return await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      ).timeout(const Duration(seconds: 12));
    } catch (e) {
      print("❌ تعذر جلب الموقع المباشر: $e");
      // نرفع استثناء مخصص ليشير إلى أن الـ GPS لم يستجب
      throw Exception("LOCATION_TIMEOUT");
    }
  }

  Future<void> moveToCurrentLocation() async {
    try {
      final position = await getCurrentLocation();
      await setLocation(position.latitude, position.longitude);
    } catch (e) {
      print("Error while fetching current location: $e");
      rethrow; // لكي يمسك الـ Screen / Controller الأعلى بالخطأ ويُظهر Snackbar للزبون
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



/*  Future<void> moveToCurrentLocation() async {
    try {
      final position = await getCurrentLocation();
      await setLocation(position.latitude, position.longitude);
    } catch (e) {
      print("Error while fetching current location: $e");
      // نرجع نرفع الاستثناء ليرى الـ Screen / Controller الأعلى أن هناك مشكلة ويظهر الرسالة
      rethrow;
    }
  }*/

/* Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> moveToCurrentLocation() async {
    try {
      final position = await getCurrentLocation();
      await setLocation(position.latitude, position.longitude);
    } catch (e) {
      print("Error while fetching current location: $e");
    }
  }*/