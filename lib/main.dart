import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'language/Language.dart';
import 'language/Language_Controller.dart';
import 'modules/Home/Home_Screen.dart';
import 'modules/SignIn/SignIn_Screen.dart';
import 'modules/Splash/Splash_Screen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(MyLanguageController());
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final myLanguageController = Get.find<MyLanguageController>();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home:  SignInScreen(),
      locale:myLanguageController.intiLanguage.value,
      translations: MyLanguage(),
      getPages: [
        GetPage(name: '/signIn', page: ()=>const SignInScreen()),
        GetPage(name: '/homeScreen', page: ()=> HomeScreen()),

      ],
    );
  }
}

