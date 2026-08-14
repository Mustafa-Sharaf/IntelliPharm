import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellipharm/app_theme/AppColors.dart';
import 'package:intl/intl.dart';
import '../../Widgets/ProfileHeaderCard.dart';
import '../../Widgets/ProfileStatTile.dart';
import '../../Widgets/TargetProgressCard.dart';
import '../../app_theme/theme_extension.dart';
import 'Profile_Controller.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final formatter = NumberFormat('#,##0.0#');
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colors.backgroundMain,
      appBar: AppBar(
        title: Text(
          'Representative Profile'.tr,
          style: TextStyle(
            color: colors.textPrimary,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Get.back(),
        ),
        backgroundColor: colors.backgroundMain,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }
        final data = controller.profileData.value;
        if (data == null) {
          return Center(
            child: Text(
              'failed_to_load_profile'.tr,
              style: TextStyle(color: colors.textPrimary, fontFamily: 'Cairo'),
            ),
          );
        }
        final rep = data.rep;
        final stats = data.stats;
        return RefreshIndicator(
          onRefresh: controller.getProfile,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeaderCard(rep: rep),
                SizedBox(height: size.height * 0.02),
                ProfileStatTile(
                  title: 'Active Clients'.tr,
                  value: stats.activeClients.toString(),
                  icon: Icons.people_outline,
                ),
                SizedBox(height: size.height * 0.01),
                ProfileStatTile(
                  title: 'Orders this month'.tr,
                  value: stats.ordersThisMonth.toString(),
                  icon: Icons.shopping_cart_outlined,
                ),
                SizedBox(height: size.height * 0.01),
                ProfileStatTile(
                  title: 'Average Deal Size'.tr,
                  value: '${formatter.format(stats.avgDealSize)} S.p',
                  icon: Icons.account_balance_wallet_outlined,
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  'Performance Targets'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                ...data.targetStats.map(
                  (target) =>
                      TargetProgressCard(target: target, formatter: formatter),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
