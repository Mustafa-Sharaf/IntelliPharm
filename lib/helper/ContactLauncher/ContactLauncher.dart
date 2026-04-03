import 'package:url_launcher/url_launcher.dart';

class ContactLauncher {

  /// 🔹 تنظيف وتحويل الرقم لصيغة دولية
  static String formatPhone(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleaned.startsWith('0')) {
      cleaned = '963${cleaned.substring(1)}'; // سوريا
    }

    return cleaned;
  }

  /// ✅ واتساب
  static Future<void> openWhatsApp(String phone) async {
    final formatted = formatPhone(phone);
    final message = Uri.encodeComponent("مرحبا، بدي استفسر عن الأدوية");

    final uri = Uri.parse("https://wa.me/$formatted?text=$message");

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }


  static Future<void> openTelegram(String value) async {
    final uri = Uri.parse(
      value.startsWith('@')
          ? "https://t.me/${value.substring(1)}"
          : "https://t.me/$value",
    );

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  /// ✅ اتصال مباشر
  static Future<void> callPhone(String phone) async {
    final formatted = formatPhone(phone);
    final uri = Uri.parse("tel:$formatted");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw "Cannot make a call";
    }
  }
}