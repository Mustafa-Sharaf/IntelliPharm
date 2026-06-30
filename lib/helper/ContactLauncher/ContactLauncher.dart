import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '../../app_theme/theme_extension.dart';

class ContactLauncher {
  Future<void> showContactOptions(BuildContext context, String phone) async {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;

    final localPhone = phone.replaceAll(RegExp(r'\D'), '');
    String whatsappPhone = localPhone;
    if (whatsappPhone.startsWith('0')) {
      whatsappPhone = '963${whatsappPhone.substring(1)}';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.backgroundMain,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  Text(
                    "Choose a method of communication",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                      fontFamily: 'Cairo',
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  _contactItem(
                    icon: FontAwesomeIcons.whatsapp,
                    iconColor: const Color(0xFF25D366),
                    title: "WhatsApp",
                    subtitle: "Start a live chat",
                    onTap: () async {
                      Navigator.pop(context);
                      await launchUrl(
                        Uri.parse('https://wa.me/$whatsappPhone'),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    color: colors,
                  ),

                  SizedBox(height: size.height * 0.02),

                  _contactItem(
                    icon: Icons.call,
                    iconColor: const Color(0xFF2196F3),
                    title: "Telephone call",
                    subtitle: "Making a voice call",
                    onTap: () async {
                      Navigator.pop(context);
                      await launchUrl(
                        Uri.parse('tel:$localPhone'),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    color: colors,
                  ),

                  SizedBox(height: size.height * 0.02),

                  _contactItem(
                    icon: Icons.sms,
                    iconColor: const Color(0xFFFF9800),
                    title: "Text message",
                    subtitle: "Send SMS",
                    onTap: () async {
                      Navigator.pop(context);
                      await launchUrl(
                        Uri.parse('sms:$localPhone'),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    color: colors,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _contactItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ThemeColors color,
  }) {
    return Material(
      color: color.component,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: iconColor.withValues(alpha: 0.3),
                child: Icon(icon, color: iconColor, size: 25),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: color.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
