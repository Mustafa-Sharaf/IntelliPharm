import 'package:flutter/material.dart';
import '../../app_theme/theme_extension.dart';

class BuildAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? trailing;

  const BuildAppbar({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return AppBar(
      backgroundColor: colors.backgroundMain,
      foregroundColor: colors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'Cairo',
          color: colors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (trailing != null) ...[trailing!, const SizedBox(width: 8)],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
