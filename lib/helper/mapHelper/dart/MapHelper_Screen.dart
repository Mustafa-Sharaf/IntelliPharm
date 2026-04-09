import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../app_theme/AppColors.dart';
import '../../../app_theme/theme_extension.dart';
import 'MapHelper_Controller.dart';

class MapHelperScreen extends StatelessWidget {
  const MapHelperScreen({super.key,required this.tag, this.height, this.bottom, this.right});
  final String tag;
  final double? height;
  final double? bottom;
  final double? right;

  @override
  Widget build(BuildContext context) {
    final mapHelperController = Get.find<MapHelperController>(tag: tag);
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: height,
            child: Obx(
              () => GoogleMap(
                /*onMapCreated: (mapCtrl) async {
                  mapHelperController.mapController.value = mapCtrl;

                  await Future.delayed(Duration(milliseconds: 100));

                  mapHelperController.applyMapStyle();
                },*/
                onMapCreated: (mapCtrl) {
                  mapHelperController.setMapController(mapCtrl);
                },

                polylines: mapHelperController.polylines,
                markers: mapHelperController.markers, // ✅ لازم هيك
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    mapHelperController.latitude.value,
                    mapHelperController.longitude.value,
                  ),
                  zoom: 14,
                ),
                //markers: {mapHelperController.pharmacyMarker.value},

                onTap: (point) {
                  mapHelperController.setLocation(
                    point.latitude,
                    point.longitude,
                  );
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
              ),
            ),
          ),
        ),
        Positioned(
          right: right,
          bottom: bottom,
          child: FloatingActionButton(
            onPressed: mapHelperController.moveToCurrentLocation,
            backgroundColor: colors.component,
            child: Icon(Icons.my_location, color: AppColors.primaryColor),
          ),
        ),
      ],
    );
  }
}
