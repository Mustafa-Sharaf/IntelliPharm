
import 'package:flutter/material.dart';
import '../app_theme/theme_extension.dart';

class SelectablePharmacyCard extends StatelessWidget {
  final int id;
  final String title;
  final String subtitle;
  final bool checked;

  const SelectablePharmacyCard({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.checked,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.014),
      padding:  EdgeInsets.all(size.height * 0.014),
      decoration: BoxDecoration(
        color: checked ? colors.component : colors.component.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: size.height * 0.025,
            height: size.height * 0.025,
            decoration: BoxDecoration(
              color: checked ? colors.textPrimary : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: checked ?  colors.textPrimary : Colors.grey.shade400,
              ),
            ),
            child: checked
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
           SizedBox(width: size.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: checked ? colors.textPrimary : Colors.grey,
                  ),
                ),
                 SizedBox(height: size.height * 0.006),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Cairo',
                    color: checked ? colors.textSecondary : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(radius: checked ? 6 : 4, backgroundColor: getColorFromId(id)),
        ],
      ),
    );
  }
}
Color getColorFromId(int id) {
  final mixed = id * 2654435761;
  final index = mixed.abs() % palette.length;
  return palette[index];
}

final List<Color> palette = [
  Colors.teal,
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.red,
  Colors.cyan,
  Colors.indigo,
  Colors.amber,
  Colors.pink,
  Colors.lime,
  Colors.deepOrange,
];