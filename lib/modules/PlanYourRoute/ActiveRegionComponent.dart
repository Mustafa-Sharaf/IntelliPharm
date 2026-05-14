


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Widgets/RegionSelector/RegionSelector_Screen.dart';
import '../../app_theme/theme_extension.dart';
import 'PlanYourRoute_Controller.dart';
class ActiveRegionComponent extends StatelessWidget {
  const ActiveRegionComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final controller = Get.put(PlanYourRouteController());
    return Column(
      children: [
        /// Active Region
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "ACTIVE REGION",
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
        SizedBox(height: size.height * 0.008),

        GestureDetector(
          onTap: () async {
            final result = await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              builder: (context) {
                return RegionSelector();
              },
            );
            if (result != null) {

              controller.selectedRegion.value = result;

              controller.fetchPharmacies(result.id);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffC9D8EB),
              borderRadius: BorderRadius.circular(14),
              border: const Border(
                bottom: BorderSide(color: Color(0xff002755), width: 3),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.map_outlined, color: colors.textPrimary),
                SizedBox(width: 10),
                Expanded(
                  child: Obx(
                        () => Text(
                      controller.selectedRegion.value?.name ??
                          "Select Region",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Cairo',
                        color: Color(0xff1E1E1E),
                      ),
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ),
        ),

      ],
    );
  }
}
