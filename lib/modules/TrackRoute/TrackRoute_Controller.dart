/*

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../../services/ApiService.dart';
import 'TrackRoute_Model.dart';

class TrackRouteController extends GetxController {

  var selectedRegion = ''.obs;
  var selectedType = ''.obs;
  final detailsController = TextEditingController();

  var isLoading = false.obs;
  var plan = Rxn<PlanModel>();

  ///
  Future<void> initiatePlan({
    required double lat,
    required double lng,
    required int regionId,
  }) async {
    try {
      isLoading.value = true;

      final response = await ApiService.post(
        "/planner/v1/plans/initiate",
        data: {
          "current_longitude": lng,
          "current_latitude": lat,
          "reason": selectedType.value.contains("New")
              ? "initiated"
              : "updated",
          "reason_details": detailsController.text,
          "region_id": regionId,
        },
      );

      if (response.data['isSuccess']) {
        plan.value = PlanModel.fromJson(response.data['data']);
        drawRoute();
      } else {
        Get.snackbar(
            "Error",
            response.data['message']
        );
        print("response.data['message']=${response.data['message']}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      if (e is DioException) {
        print("STATUS: ${e.response?.statusCode}");
        print("DATA: ${e.response?.data}");
      }
    } finally {
      isLoading.value = false;
    }
  }


 */
/* void drawRoute() {
    final mapController = Get.find<MapHelperController>(tag: "route");

    List<List<LatLng>> allPaths = [];

    mapController.clearAll(); // مهم

    for (var path in plan.value!.paths) {
      final decoded = decodePolyline(path.geometry);

      allPaths.add(decoded);

      /// 📍 خذ آخر نقطة (تمثل الصيدلية)
      if (decoded.isNotEmpty) {
        final lastPoint = decoded.last;

        mapController.addMarker(
          position: lastPoint,
          title: "Visit ${path.to}",
        );

      }
    }

    mapController.drawRoutes(allPaths);
  }*//*

  void drawRoute() {
    final mapController = Get.find<MapHelperController>(tag: "route");

    List<List<LatLng>> allPaths = [];

    mapController.clearAll(); // 🧹 مرة وحدة فقط

    for (var path in plan.value!.paths) {
      final decoded = decodePolyline(path.geometry);

      allPaths.add(decoded);
    }

    /// 🛣️ ارسم المسارات
    mapController.drawRoutes(allPaths);

    /// 📍 بعدها أضف الماركرز
    for (var path in plan.value!.paths) {
      final decoded = decodePolyline(path.geometry);

      if (decoded.isNotEmpty) {
        final lastPoint = decoded.last;

        mapController.addMarker(
          position: lastPoint,
          title: "Visit ${path.to}",
        );
      }
    }
  }
  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];

    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }
}*/
