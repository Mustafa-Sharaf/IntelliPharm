import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intellipharm/services/DioClient.dart';
import 'app_theme/app_theme.dart';
import 'app_theme/theme_controller.dart';
import 'helper/mapHelper/dart/MapHelper_Controller.dart';
import 'language/Language.dart';
import 'language/Language_Controller.dart';
import 'modules/Home/Home_Screen.dart';
import 'modules/PlanYourRoute/PlanYourRoute_Controller.dart';
import 'modules/SignIn/SignIn_Screen.dart';
import 'modules/Splash/Splash_Screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  DioClient.init();
  Get.put(MyLanguageController());
  Get.put(MapHelperController(), tag: "route");
  Get.put(MapHelperController(), tag: "addPharmacy");
  final themeController = Get.put(ThemeController());
  Get.put(PlanYourRouteController());
  themeController.loadThemeFromStorage();
  final box = GetStorage();
  final token = box.read<String>('token');
  runApp(MyApp(initialRoute: token == null ? '/splash' : '/homeScreen'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myLanguageController = Get.find<MyLanguageController>();
    final ThemeController themeController = Get.find();
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: initialRoute,
        locale: myLanguageController.intiLanguage.value,
        translations: MyLanguage(),
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,

        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        getPages: [
          GetPage(name: '/splash', page: () => SplashScreen()),
          GetPage(name: '/signIn', page: () => SignInScreen()),
          GetPage(name: '/homeScreen', page: () => HomeScreen()),
        ],
      ),
    );
  }
}
