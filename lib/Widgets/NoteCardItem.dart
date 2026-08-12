
import 'package:flutter/material.dart';
import '../../app_theme/theme_extension.dart';
import '../../modules/PharmacyDetails/ColorClassHelper.dart';
import '../../modules/PharmacyDetails/PharmacyDetails_Model.dart';
import 'package:get/get.dart';


class NoteCardItem extends StatelessWidget {
  final HistoryNote note;
  final int index;
  final int totalItems;
  final Size size;
  final ThemeColors colors;

  const NoteCardItem({
    super.key,
    required this.note,
    required this.index,
    required this.totalItems,
    required this.size,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardBg = ColorClassHelper().getCardColor(note.noteType, isDarkMode);
    final txtColor = ColorClassHelper().getTextColor(note.noteType, isDarkMode);
    final tagBg = ColorClassHelper().getTagColor(note.noteType, isDarkMode);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 5,
              backgroundColor: txtColor,
            ),
            if (index != totalItems - 1)
              Container(
                width: 2,
                height: size.height * 0.14,
                color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
              ),
          ],
        ),
        SizedBox(width: size.width * 0.02),

        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: size.height * 0.009),
            padding: EdgeInsets.all(size.width * 0.03),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFF0F2547),
                      child: Text(
                        note.authorName.substring(0, note.authorName.length > 2 ? 2 : note.authorName.length).toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo'
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.01),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.authorName,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                                fontFamily: 'Cairo'
                            ),
                          ),
                           Text(
                            "TeamMember".tr,
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontFamily: 'Cairo'
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      note.createdAt.split(' ').first,
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontFamily: 'Cairo'
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.015),

                Text(
                  note.content,
                  style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: colors.textPrimary.withValues(alpha: 0.9),
                      fontFamily: 'Cairo'
                  ),
                ),
                SizedBox(height: size.height * 0.015),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDarkMode ? tagBg : tagBg.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    note.noteType.toUpperCase(),
                    style: TextStyle(
                        fontSize: 10,
                        color: txtColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo'
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}