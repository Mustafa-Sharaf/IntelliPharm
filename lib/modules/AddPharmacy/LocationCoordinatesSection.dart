import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/theme_extension.dart';
import '../../helper/mapHelper/dart/MapHelper_Controller.dart';

class LocationCoordinateSection extends StatelessWidget {
  const LocationCoordinateSection({super.key});

  @override
  Widget build(BuildContext context) {
    final mapController = Get.find<MapHelperController>(tag: "addPharmacy");
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(size.height * 0.03),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: size.width * 0.01),
                    Text(
                      'Latitude',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const Text(' *', style: TextStyle(color: Colors.red)),
                  ],
                ),
                Container(
                  height: size.height * 0.05,
                  width: size.width * 0.3,
                  alignment: AlignmentDirectional.centerStart,
                  decoration: BoxDecoration(
                    color: colors.backgroundMain,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.02,
                    ),
                    child: Obx(
                      () => Text(
                        "${mapController.latitude.value}",
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textDefault,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: size.width * 0.1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: size.width * 0.01),
                    Text(
                      'Longitude',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const Text(' *', style: TextStyle(color: Colors.red)),
                  ],
                ),
                Container(
                  height: size.height * 0.05,
                  width: size.width * 0.3,
                  alignment: AlignmentDirectional.centerStart,
                  decoration: BoxDecoration(
                    color: colors.backgroundMain,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.02,
                    ),
                    child: Obx(
                      () => Text(
                        "${mapController.longitude.value}",
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textDefault,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
