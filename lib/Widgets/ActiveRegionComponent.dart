
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'RegionSelector/RegionSelector_Screen.dart';
import '../app_theme/theme_extension.dart';

class ActiveRegionComponent extends StatelessWidget {
  const ActiveRegionComponent({
    super.key,
    required this.text,
    required this.selectedRegionName,
    required this.onRegionSelected,
  });

  final String text;
  final String? selectedRegionName;
  final Function(dynamic) onRegionSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        /// Active Region
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: colors.textSecondary,
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
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              builder: (context) {
                return RegionSelector();
              },
            );
            if (result != null) {
              onRegionSelected(result);
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
              border: Border(
                bottom: BorderSide(color: colors.textPrimary, width: 3),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.map_outlined, color: colors.textPrimary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selectedRegionName ?? "SelectRegion".tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      color: Color(0xff1E1E1E),
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}