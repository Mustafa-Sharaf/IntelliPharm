import 'package:flutter/material.dart';

import '../../app_theme/theme_extension.dart';
import 'Searching_Controller.dart';



class CustomSearchField extends StatelessWidget {
  final SearchControllerX controller;

  const CustomSearchField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(16),
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
            onChanged: controller.onChanged,
            decoration: InputDecoration(
              hintText: "Search medicines...",
              hintStyle: TextStyle(color: colors.textSecondary),

              prefixIcon: Icon(Icons.search, color: colors.textSecondary),

              suffixIcon: value.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.close, color: colors.textSecondary),
                onPressed: controller.clear,
              )
                  : null,

              border: InputBorder.none,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 14),
            ),
          );
        },
      ),
    );
  }
}