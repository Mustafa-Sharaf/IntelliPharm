import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import '../app_theme/theme_extension.dart';
import '../helper/ContactLauncher/ContactLauncher.dart';
import '../modules/Pharmacists/Pharmacists_Model.dart';

class PharmacyCard extends StatelessWidget {
  final PharmaciesModel pharmacy;

  const PharmacyCard({super.key, required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return Card(
      color: colors.component,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Card(
        color: colors.component,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Hero(
                  tag: "pharmacy_${pharmacy.id}",
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.12,
                    height: MediaQuery.of(context).size.width * 0.12,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.local_pharmacy,
                      color: AppColors.primaryColor,
                      size: 28,
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pharmacy.name,
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    /*  SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005,
                      ),*/
                      const SizedBox(height: 6),

                      Row(
                        children: [
                          Text("🗺️️", style: TextStyle(fontSize: 14)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),
                          Text(
                            pharmacy.region,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                     /* SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005,
                      ),*/
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text("👨‍⚕️", style: TextStyle(fontSize: 14)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),
                          Text(
                            pharmacy.pharmacistName ?? "No_name".tr,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005,
                      ),
                      Row(
                        children: [
                          Text("📱️", style: TextStyle(fontSize: 14)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),
                          Text(
                            pharmacy.pharmacistPhone,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.blueGrey,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                     /* SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005,
                      ),*/
                      const SizedBox(height: 6),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            Text(
                              "${pharmacy.openingTime} - ${pharmacy.closingTime}",
                              style: TextStyle(
                                fontSize: 12.5,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    _buildActionButton(
                        icon: FontAwesomeIcons.whatsapp,
                        color: const Color(0xFF25D366),
                        onTap: () async {
                          try {
                            await ContactLauncher.openWhatsApp(pharmacy.pharmacistPhone);
                          } catch (e) {
                            Get.snackbar("Error", "WhatsApp not available");
                          }
                        },
                        context: context
                    ),
                     SizedBox(height: MediaQuery.of(context).size.height *0.03),
                    _buildActionButton(
                        icon: FontAwesomeIcons.telegram,
                        color: const Color(0xFF0088cc),
                        onTap: () async {
                          try {
                            await ContactLauncher.openTelegram(pharmacy.pharmacistPhone);
                          } catch (e) {
                            Get.snackbar("Error", "Telegram not available");
                          }
                        },
                        context: context
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required context,
  }) {
    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: color.withValues(alpha: 0.4),
        highlightColor: color.withValues(alpha: 0.2),
        child: Container(
          width:  MediaQuery.of(context).size.width * 0.1,
          height: MediaQuery.of(context).size.width * 0.1,
          alignment: Alignment.center,
          child: FaIcon(icon, color: color, size: 25),
        ),
      ),
    );
  }
}
