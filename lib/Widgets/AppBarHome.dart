import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../helper/DateHelper.dart';

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
    final name = user?["name"] ?? "User";
    final width = MediaQuery.of(context).size.width;
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xfff2f2f2),
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
              color: Color(0xff002653),
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
                  "Hi, $name",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Cairo',
                    color: Color(0xff002653),
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
                    color: Color(0xff43474F),
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
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_none,
                  color: Color(0xff002653),
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
