import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class ContactLauncher {
  Future<void> showContactOptions(
      BuildContext context,
      String phone,
      ) async {

    final localPhone = phone.replaceAll(RegExp(r'\D'), '');
    String whatsappPhone = localPhone;
    if (whatsappPhone.startsWith('0')) {
      whatsappPhone = '963${whatsappPhone.substring(1)}';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "اختر طريقة التواصل",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                _contactItem(
                  icon: FontAwesomeIcons.whatsapp,
                  color: Colors.green,
                  title: "واتساب",
                  subtitle: "بدء محادثة",
                  onTap: () async {
                    Navigator.pop(context);
                    await launchUrl(
                      Uri.parse('https://wa.me/$whatsappPhone'),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),

                const SizedBox(height: 12),

                _contactItem(
                  icon: Icons.call,
                  color: Colors.blue,
                  title: "اتصال",
                  subtitle: "إجراء مكالمة",
                  onTap: () async {
                    Navigator.pop(context);
                    await launchUrl(
                      Uri.parse('tel:$localPhone'),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),

                const SizedBox(height: 12),

                _contactItem(
                  icon: Icons.sms,
                  color: Colors.orange,
                  title: "رسالة",
                  subtitle: "إرسال SMS",
                  onTap: () async {
                    Navigator.pop(context);
                    await launchUrl(
                      Uri.parse('sms:$localPhone'),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _contactItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withValues(alpha: 0.015),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}