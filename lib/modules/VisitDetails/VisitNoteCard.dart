import 'package:flutter/material.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../../app_theme/theme_extension.dart';

class VisitNoteCard extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final bool isGeneralNote;

  const VisitNoteCard({
    super.key,
    required this.text,
    required this.backgroundColor,
    this.isGeneralNote = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final IconData icon = isGeneralNote
        ? Icons.chat_bubble_outline_rounded
        : Icons.info_outline_rounded;

    final Color accentColor = isGeneralNote
        ? AppColors.primaryColor
        : const Color(0xFF0288D1);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.component,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 5, color: accentColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, size: 20, color: accentColor),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.textSecondary,
                          height: 1.4,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
