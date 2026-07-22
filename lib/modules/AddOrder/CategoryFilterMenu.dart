import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../AddOrder/AddOrder_Controller.dart';

class CategoryFilterMenu extends StatelessWidget {
  const CategoryFilterMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    final addOrderController = Get.find<AddOrderController>();

    return SizedBox(
      width: size.width * 0.12,
      height: size.width * 0.12,
      child: Obx(() {
        final hasCategoryFilter =
            addOrderController.selectedCategoryId.value != null;

        return PopupMenuButton<int?>(
          onOpened: () {
            addOrderController.categorySearchQuery.value = '';
          },
          offset: const Offset(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          color: colors.component,
          elevation: 8,
          itemBuilder: (context) {
            return [
              PopupMenuItem<int?>(
                enabled: false,
                child: Container(
                  width: size.width * 0.6,
                  padding: EdgeInsets.symmetric(vertical: size.width * 0.04),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onChanged: (val) {
                          addOrderController.categorySearchQuery.value = val;
                        },
                        style: TextStyle(
                          color: colors.textDefault,
                          fontSize: 13,
                          fontFamily: 'Cairo',
                        ),
                        decoration: InputDecoration(
                          hintText: "Search...".tr,
                          hintStyle: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 13,
                            fontFamily: 'Cairo',
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: colors.textSecondary,
                            size: 18,
                          ),
                          isDense: true,
                          filled: true,
                          fillColor: colors.backgroundMain,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Divider(color: colors.textSecondary.withValues(alpha: 0.2), height: 1,),
                      SizedBox(height: size.height * 0.01),

                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 280),
                        child: SingleChildScrollView(
                          controller: addOrderController.categoryScrollController,
                          child: Obx(() {
                            final filtered =
                                addOrderController.filteredCategories;
                            final selectedId =
                                addOrderController.selectedCategoryId.value;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                CategoryTileWidget(
                                  title: "All_Categories".tr,
                                  isSelected: selectedId == null,
                                  onTap: () {
                                    addOrderController.selectCategory(null);
                                    Get.back();
                                  },
                                ),
                                ...filtered.map(
                                  (cat) => CategoryTileWidget(
                                    title: cat.name,
                                    isSelected: selectedId == cat.id,
                                    onTap: () {
                                      addOrderController.selectCategory(cat.id);
                                      Get.back();
                                    },
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colors.textPrimary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.tune,
                    color: AppColors.backgroundColorLight,
                    size: size.width * 0.06,
                  ),
                ),
              ),
              if (hasCategoryFilter)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class CategoryTileWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryTileWidget({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.primaryColor : colors.textDefault,
            fontSize: 13,
            fontFamily: 'Cairo',
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
