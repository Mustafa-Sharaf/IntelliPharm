import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'modules/SignIn/SignIn_Screen.dart';
import 'modules/Splash/Splash_Screen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home:  SplashScreen(),
      getPages: [
        GetPage(name: '/signIn', page: ()=>const SignInScreen()),

      ],
    );
  }
}

