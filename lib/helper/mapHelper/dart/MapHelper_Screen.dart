
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../app_theme/AppColors.dart';
import '../../../app_theme/theme_extension.dart';
import '../../../modules/RePlanRoute/RePlanRoute_Screen.dart';
import 'MapHelper_Controller.dart';

class MapHelperScreen extends StatelessWidget {
  const MapHelperScreen({
    super.key,
    required this.tag,
    this.height,
    this.showMyLocationButton = true,
    this.bottom,
    this.right,
    this.showRefreshButton = false,
    this.refreshButtonBottom,
    this.refreshButtonRight,
  });

  final String tag;
  final double? height;
  final bool showMyLocationButton;
  final double? bottom;
  final double? right;
  final bool showRefreshButton;
  final double? refreshButtonBottom;
  final double? refreshButtonRight;

  @override
  Widget build(BuildContext context) {
    final mapHelperController = Get.find<MapHelperController>(tag: tag);
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return Stack(
      children: [
        /// MAP
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: height,
            child: Obx(() {
              final lat = mapHelperController.latitude.value;
              final lng = mapHelperController.longitude.value;
              final isDark = Get.isDarkMode;
              return GoogleMap(
                key: ValueKey("map_${isDark}_${lat}_$lng"),

                onMapCreated: (mapCtrl) {
                  mapHelperController.setMapController(mapCtrl);
                },
                polylines: mapHelperController.polylines,
                markers: mapHelperController.markers,
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat, lng),
                  zoom: 14,
                ),
                onTap: (point) {
                  mapHelperController.setLocation(
                    point.latitude,
                    point.longitude,
                  );
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
              );
            }),
          ),
        ),

        /// FIRST BUTTON
        if (showMyLocationButton)
          Positioned(
            right: right,
            bottom: bottom,
            child: FloatingActionButton(
              mini: true,
              onPressed: mapHelperController.moveToCurrentLocation,
              backgroundColor: colors.component,
              child: const Icon(
                Icons.my_location,
                color: AppColors.primaryColor,
                size: 18,
              ),
            ),
          ),

        if (showRefreshButton)
          Positioned(
            right: refreshButtonRight,
            bottom: refreshButtonBottom,
            child: FloatingActionButton(
              mini: true,
              onPressed: () {
                Get.to(() => RePlanRouteScreen());
              },
              backgroundColor: colors.component,
              child: const Icon(
                Icons.refresh,
                color: AppColors.primaryColor,
                size: 18,
              ),
            ),
          ),
      ],
    );
  }
}