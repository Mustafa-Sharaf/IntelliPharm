
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class LocationHelperService {
  static final Dio _dio = Dio();

  static Future<String> getAddressFromCoordinates(double lat, double lng) async {
    try {
      final String currentLanguage = Get.locale?.languageCode ?? 'ar';

      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'jsonv2',
          'lat': lat,
          'lon': lng,
          'accept-language': currentLanguage,
        },
        options: Options(
          headers: {
            'User-Agent': 'IntelliPharmaApp/1.0',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final address = response.data['address'];
        if (address == null) return currentLanguage == 'ar' ? "عنوان غير دقيق" : "Imprecise address";

        List<String> parts = [];
        String nearbyLandmark = "";


        if (address['amenity'] != null) {
          nearbyLandmark = address['amenity'].toString();
        } else if (address['building'] != null && address['building'] != 'yes') {
          nearbyLandmark = address['building'].toString();
        } else if (address['shop'] != null) {
          nearbyLandmark = address['shop'].toString();
        } else if (response.data['name'] != null && response.data['name'].toString().isNotEmpty) {
          String placeName = response.data['name'].toString();
          if (placeName != address['road'] && placeName != address['suburb']) {
            nearbyLandmark = placeName;
          }
        }

        if (nearbyLandmark.isNotEmpty) {
          if (currentLanguage == 'ar') {
            parts.add("بالقرب من $nearbyLandmark");
          } else {
            parts.add("Near $nearbyLandmark");
          }
        }

        if (address['road'] != null) {
          parts.add(address['road'].toString());
        }


        if (address['suburb'] != null) parts.add(address['suburb'].toString());
        if (address['neighbourhood'] != null) parts.add(address['neighbourhood'].toString());


        if (address['city'] != null) {
          parts.add(address['city'].toString());
        } else if (address['town'] != null) {
          parts.add(address['town'].toString());
        }

        if (address['state'] != null) parts.add(address['state'].toString());

        final cleanParts = parts.where((p) => p.isNotEmpty).toSet().toList();

        final result = cleanParts.join(' - ');
        return result.isNotEmpty
            ? result
            : (currentLanguage == 'ar' ? "عنوان غير محدد بدقة" : "Address not specified accurately");
      }

      return currentLanguage == 'ar' ? "لم يتم تحديد الموقع" : "Location not determined";
    } catch (e) {
      //print("⚠️ خطأ في جلب العنوان التفصيلي: $e");
      final String currentLanguage = Get.locale?.languageCode ?? 'ar';
      return currentLanguage == 'ar' ? "لم يتم تحديد الموقع" : "Location not determined";
    }
  }
}