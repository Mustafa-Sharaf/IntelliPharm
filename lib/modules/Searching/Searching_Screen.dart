/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../AddOrder/AddOrder_Controller.dart';
import 'Searching_Controller.dart';

class CustomSearchField extends StatelessWidget {
  final SearchControllerX controller;

  const CustomSearchField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        Container(
          width: size.width * 0.8,
          decoration: BoxDecoration(
            color: colors.component,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: ValueListenableBuilder(
            valueListenable: controller.searchText,
            builder: (context, value, _) {
              return TextField(
                controller: controller.textController,
                onChanged: (value) {
                  controller.onChanged(value);
                  Get.find<AddOrderController>().onSearchChanged(value);
                },
                decoration: InputDecoration(
                  hintText: "Search medicines...",
                  hintStyle: TextStyle(
                    color: colors.textSecondary,
                    fontFamily: 'Cairo',
                  ),
                  prefixIcon: Icon(Icons.search, color: colors.textSecondary),
                  suffixIcon: value.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.close, color: colors.textSecondary),
                          onPressed: () {
                            controller.clear();
                            Get.find<AddOrderController>().onSearchChanged('');
                          },
                        )
                      : null,

                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              );
            },
          ),
        ),
        SizedBox(width: size.width * 0.01),
        SizedBox(
          width: size.width * 0.12,
          height: size.width * 0.12,
          child: ElevatedButton(
            onPressed: () async {

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.textPrimary,
              elevation: 3,
              padding: EdgeInsets.zero,
              shape: const CircleBorder(),
            ),
            child: Icon(Icons.tune,
              color: AppColors.backgroundColorLight,
              size: size.width * 0.06,
            ),
          ),
        ),
      ],
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';
import '../AddOrder/AddOrder_Controller.dart';
import 'Searching_Controller.dart';

class CustomSearchField extends StatelessWidget {
  final SearchControllerX controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const CustomSearchField({
    super.key,
    required this.controller,
    this.hintText,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        Container(
          width: size.width * 0.8,
          decoration: BoxDecoration(
            color: colors.component,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: ValueListenableBuilder(
            valueListenable: controller.searchText,
            builder: (context, value, _) {
              return TextField(
                controller: controller.textController,
                onChanged: (val) {
                  controller.onChanged(val);

                  // 💡 إذا تم تمرير onChanged خارجي (مثل شاشة الصيدليات) نفذه، وإلا نفذ الافتراضي للأدوية
                  if (onChanged != null) {
                    onChanged!(val);
                  } else {
                    // السلوك الافتراضي القديم للأدوية
                    if (Get.isRegistered<AddOrderController>()) {
                      Get.find<AddOrderController>().onSearchChanged(val);
                    }
                  }
                },
                decoration: InputDecoration(
                  // 💡 نص ديناميكي: إذا لم يمرر، يضع النص الافتراضي للأدوية
                  hintText: hintText ?? "Search medicines...",
                  hintStyle: TextStyle(
                    color: colors.textSecondary,
                    fontFamily: 'Cairo',
                  ),
                  prefixIcon: Icon(Icons.search, color: colors.textSecondary),
                  suffixIcon: value.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.close, color: colors.textSecondary),
                    onPressed: () {
                      controller.clear();

                      // 💡 عند الضغط على زر الحذف (X)
                      if (onClear != null) {
                        onClear!();
                      } else {
                        if (Get.isRegistered<AddOrderController>()) {
                          Get.find<AddOrderController>().onSearchChanged('');
                        }
                      }
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              );
            },
          ),
        ),
        SizedBox(width: size.width * 0.01),
        SizedBox(
          width: size.width * 0.12,
          height: size.width * 0.12,
          child: ElevatedButton(
            onPressed: () async {
              // هنا يمكن فتح BottomSheet للفلترة المتقدمة لاحقاً
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.textPrimary,
              elevation: 3,
              padding: EdgeInsets.zero,
              shape: const CircleBorder(),
            ),
            child: Icon(Icons.tune,
              color: AppColors.backgroundColorLight,
              size: size.width * 0.06,
            ),
          ),
        ),
      ],
    );
  }
}