import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../app_theme/theme_extension.dart';
import '../helper/DateHelper.dart';
import '../modules/Notifications/Notifications_Screen.dart';

//New code
class AppbarHome extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AppbarHome({super.key, required this.scaffoldKey});

  @override
  Size get preferredSize => const Size.fromHeight(70);


  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final user = box.read("user");
    final name = user?["name"] ?? "User".tr;
    final width = MediaQuery.of(context).size.width;
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: colors.backgroundMain,
      elevation: 0,
      title: Row(
        children: [
          /// MENU
          IconButton(
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color:colors.textPrimary ,//Color(0xff002653)
              size: width * 0.06,
            ),
          ),

          /// TEXTS
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "HI_USER".trParams({
                    'name': name,
                  }),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Cairo',
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  DateHelper.getFormattedDate(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'Cairo',
                    color: colors.textSecondary,//Color(0xff43474F),
                    height: 1,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          ///NOTIFICATION
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Get.to(()=>NotificationsScreen());
                },
                icon: Icon(
                  Icons.notifications_none,
                  color: colors.textPrimary,
                  size: width * 0.06,
                ),
              ),

              ///DOT
              Positioned(
                right: 15,
                top: 12,
                child: CircleAvatar(
                  radius: width * 0.01,
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
