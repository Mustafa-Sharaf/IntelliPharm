import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../language/Language_Controller.dart';

class LanguageBottomSheet extends StatelessWidget {
  final MyLanguageController langController = Get.find<MyLanguageController>();

  LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "LanguageEditing".tr,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.025),
          ListTile(
            leading: Image.asset("assets/images/Syria.png", width: 50),
            title: Text(
                "العربية",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Cairo',
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              langController.changeLanguage("ar");
              Get.back();
            },
          ),
          Divider(),
          ListTile(
            leading: Image.asset("assets/images/Britain.png", width: 50),
            title: Text("English",  style: TextStyle(
              fontSize: 18,
              fontFamily: 'Cairo',
            ),),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              langController.changeLanguage("en");
              Get.back();
            },
          ),
          Divider(),
          ListTile(
            leading: Image.asset("assets/images/Franca.png", width: 50),
            title: Text("Français",  style: TextStyle(
              fontSize: 18,
              fontFamily: 'Cairo',
            ),),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              langController.changeLanguage("fr");
              Get.back();
            },
          ),
          Divider(),
          ListTile(
            leading: Image.asset("assets/images/Turkce.png", width: 50),
            title: Text("Türkçe",  style: TextStyle(
              fontSize: 18,
              fontFamily: 'Cairo',
            ),),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              langController.changeLanguage("tr");
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
