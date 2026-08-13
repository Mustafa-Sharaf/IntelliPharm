import 'package:flutter/material.dart';
import '../../app_theme/theme_extension.dart';
import 'Searching_Controller.dart';

class CustomSearchField extends StatelessWidget {
  final SearchControllerX controller;
  final String text;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const CustomSearchField({
    super.key,
    required this.controller,
    required this.text,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
        ],
      ),
      child: ValueListenableBuilder<String>(
        valueListenable: controller.searchText,
        builder: (context, value, _) {
          return TextField(
            controller: controller.textController,
            onChanged: (val) {
              controller.onChanged(val);
              if (onChanged != null) {
                onChanged!(val);
              }
            },
            decoration: InputDecoration(
              hintText: text,
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
                        if (onClear != null) {
                          onClear!();
                        } else if (onChanged != null) {
                          onChanged!('');
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
    );
  }
}
