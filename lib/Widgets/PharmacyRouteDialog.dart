import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../app_theme/theme_extension.dart';
import '../../helper/mapHelper/dart/MapHelper_Screen.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';
import '../helper/mapHelper/dart/MapDrawerHelper.dart';
import '../modules/ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Model.dart';
import '../modules/PharmacyDetails/PharmacyDetails_Model.dart';

class PharmacyRouteDialog extends StatelessWidget {
  final PharmacyDetailsModel pharmacy;
  final PlanResponse initialPlan;

  const PharmacyRouteDialog({
    super.key,
    required this.pharmacy,
    required this.initialPlan,
  });

  final String mapTag = "mini_route_visit";

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final miniMapController = Get.find<MapHelperController>(tag: mapTag);
    ever(miniMapController.mapController, (
      GoogleMapController? googleController,
    ) async {
      if (googleController != null) {
        miniMapController.polyLines.clear();
        miniMapController.markers.clear();
        await MapDrawerHelper.drawFullRoute(
          routeMapController: miniMapController,
          plan: initialPlan,
        );

        final LatLngBounds bounds = LatLngBounds(
          southwest: LatLng(
            miniMapController.latitude.value < pharmacy.latitude
                ? miniMapController.latitude.value
                : pharmacy.latitude,
            miniMapController.longitude.value < pharmacy.longitude
                ? miniMapController.longitude.value
                : pharmacy.longitude,
          ),
          northeast: LatLng(
            miniMapController.latitude.value > pharmacy.latitude
                ? miniMapController.latitude.value
                : pharmacy.latitude,
            miniMapController.longitude.value > pharmacy.longitude
                ? miniMapController.longitude.value
                : pharmacy.longitude,
          ),
        );
        googleController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 70),
        );
      }
    });

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: size.width * 0.90,
          height: size.height * 0.60,
          decoration: BoxDecoration(
            color: colors.backgroundMain,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Route to ${pharmacy.nameEn}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Get.delete<MapHelperController>(tag: mapTag);
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: MapHelperScreen(
                      tag: mapTag,
                      showRefreshButton: false,
                      showMyLocationButton: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
