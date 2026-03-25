import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intellipharm/services/DioClient.dart';
import 'app_theme/app_theme.dart';
import 'app_theme/theme_controller.dart';
import 'language/Language.dart';
import 'language/Language_Controller.dart';
import 'modules/AddOrder/AddOrder_Screen.dart';
import 'modules/AddPharmacy/AddPharmacy_Screen.dart';
import 'modules/Home/Home_Screen.dart';
import 'modules/Pharmacists/Pharmacists_Screen.dart';
import 'modules/SignIn/SignIn_Screen.dart';
import 'modules/Splash/Splash_Screen.dart';
import 'modules/TrackRoute/TrackRoute_Screen.dart';
import 'modules/ViewOrders/ViewOrders_Screen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  DioClient.init();
  Get.put(MyLanguageController());
  final themeController =Get.put(ThemeController());
  themeController.loadThemeFromStorage();
  final box = GetStorage();
  final token = box.read<String>('token');
  runApp( MyApp(initialRoute: token == null ? '/splash' : '/homeScreen'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myLanguageController = Get.find<MyLanguageController>();
    final ThemeController themeController = Get.find();
    return Obx(() =>GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      locale:myLanguageController.intiLanguage.value,
      translations: MyLanguage(),
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,

      themeMode: themeController.isDarkMode.value
          ? ThemeMode.dark
          : ThemeMode.light,

      getPages: [
        GetPage(name: '/splash', page: ()=> SplashScreen()),
        GetPage(name: '/signIn', page: ()=> SignInScreen()),
        GetPage(name: '/homeScreen', page: ()=> HomeScreen()),
        GetPage(name: '/pharmacistsScreen', page: ()=> PharmacistsScreen()),
        GetPage(name: '/addPharmacyScreen', page: ()=> AddPharmacyScreen()),
        GetPage(name: '/addOrderScreen', page: ()=> AddOrderScreen()),
        GetPage(name: '/viewOrdersScreen', page: ()=> ViewOrdersScreen()),
        GetPage(name: '/trackRouteScreen', page: ()=> TrackRouteScreen()),
        GetPage(name: '/trackRouteScreen', page: ()=> TrackRouteScreen()),

      ],
    ));
  }
}

