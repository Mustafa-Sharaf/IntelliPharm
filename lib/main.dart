/*

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intellipharm/modules/NewOrder/NewOrderBinding.dart';
import 'package:intellipharm/modules/NewOrder/NewOrder_Screen.dart';
import 'package:intellipharm/modules/RePlanRoute/RePlanRouteBinding.dart';
import 'package:intellipharm/services/DioClient.dart';
import 'Notifications.dart';
import 'Widgets/RouteStepItem/RouteStepBinding.dart';
import 'app_theme/app_theme.dart';
import 'app_theme/theme_controller.dart';
import 'helper/mapHelper/dart/MapHelper_Controller.dart';
import 'language/Language.dart';
import 'language/Language_Controller.dart';

// Import Bindings & Screens
import 'modules/ActiveDeliveryRoute/ActiveDeliveryRouteBinding.dart';
import 'modules/ActiveDeliveryRoute/ActiveDeliveryRoute_Screen.dart';
import 'modules/ActiveOptimizedRouteTracking/ActiveOptimizedRouteTrackingBinding.dart';
import 'modules/ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Screen.dart';
import 'modules/AddOrder/AddOrderBinding.dart';
import 'modules/AddOrder/AddOrder_Screen.dart';
import 'modules/AddPharmacy/AddPharmacyBinding.dart';
import 'modules/AddPharmacy/AddPharmacy_Screen.dart';
import 'modules/ChatGemini/ChatGemini_Screen.dart';
import 'modules/ConfirmDelivery/ConfirmDeliveryBinding.dart';
import 'modules/ConfirmDelivery/ConfirmDelivery_Screen.dart';
import 'modules/Home/HomeBinding.dart';
import 'modules/Home/Home_Screen.dart';
import 'modules/HomeContent/HomeContent_Screen.dart';
import 'modules/Notifications/NotificationsBinding.dart';
import 'modules/Notifications/Notifications_Screen.dart';
import 'modules/PlanYourRoute/PlanYourRouteBinding.dart';
import 'modules/PlanYourRoute/PlanYourRoute_Controller.dart';
import 'modules/PlanYourRoute/PlanYourRoute_Screen.dart';
import 'modules/PlanYourRoute/ReverbService.dart';
import 'modules/RePlanRoute/RePlanRoute_Screen.dart';
import 'modules/SignIn/SignInBinding.dart';
import 'modules/SignIn/SignIn_Screen.dart';
import 'modules/Splash/Splash_Screen.dart';
import 'modules/Tracking/LiveLocationTracker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => ReverbService().init());
  await GetStorage.init();
  await Firebase.initializeApp();
  await Notifications().initNotifications();
  Get.put(MapHelperController(), tag: "routeDelivery");
  Get.put(MapHelperController(), tag: "route");
  Get.put(MapHelperController(), tag: "addPharmacy");
  Get.put(MyLanguageController());
  final themeController = Get.put(ThemeController());
  Get.put(PlanYourRouteController(), permanent: true);
  Get.put(LiveLocationTracker(), permanent: true);
  themeController.loadThemeFromStorage();

  DioClient.init();

  final box = GetStorage();
  final token = box.read<String>('token');

  runApp(MyApp(initialRoute: token == null ? '/login' : '/homeScreen'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

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
          GetPage(name: '/splash', page: () => const SplashScreen()),

          GetPage(
            name: '/login',
            page: () => const SignInScreen(),
            binding: SignInBinding(),
          ),

          GetPage(
            name: '/homeScreen',
            page: () => HomeScreen(),
            binding: HomeBinding(),
          ),

          GetPage(
            name: '/activeDeliveryRoute',
            page: () => const ActiveDeliveryRouteScreen(),
            binding: ActiveDeliveryRouteBinding(),
          ),

          GetPage(
            name: '/activeOptimizedRouteTracking',
            page: () => const ActiveOptimizedRouteTrackingScreen(),
            bindings: [
              ActiveOptimizedRouteTrackingBinding(),
              RouteStepBinding(),
            ],
          ),

          GetPage(
            name: '/addOrder',
            page: () => AddOrderScreen(),
            binding: AddOrderBinding(),
          ),

          GetPage(
            name: '/addPharmacy',
            page: () => const AddPharmacyScreen(),
            binding: AddPharmacyBinding(),
          ),

          GetPage(
            name: '/chat',
            page: () => const ChatScreen(),
            binding: HomeBinding(),
          ),

          GetPage(
            name: '/confirmDelivery',
            page: () => const ConfirmDeliveryScreen(),
            binding: ConfirmDeliveryBinding(),
          ),

          GetPage(
            name: '/notifications',
            page: () => const NotificationsScreen(),
            binding: NotificationsBinding(),
          ),

          GetPage(
            name: '/planYourRoute',
            page: () => const PlanYourRouteScreen(),
            binding: PlanYourRouteBinding(),
          ),
          GetPage(
            name: '/rePlanRoute',
            page: () => const RePlanRouteScreen(),
            binding: RePlanRouteBinding(),
          ),
          GetPage(
            name: '/newOrderScreen',
            page: () => const NewOrderScreen(),
            binding: NewOrderBinding(),
          ),
          GetPage(
            name: '/homeContentScreen',
            page: () => const HomeContentScreen(),
            binding: HomeBinding(),
          ),


        ],
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intellipharm/modules/NewOrder/NewOrderBinding.dart';
import 'package:intellipharm/modules/NewOrder/NewOrder_Controller.dart';
import 'package:intellipharm/modules/NewOrder/NewOrder_Screen.dart';
import 'package:intellipharm/modules/RePlanRoute/RePlanRouteBinding.dart';
import 'package:intellipharm/services/DioClient.dart';
import 'Notifications.dart';
import 'Widgets/RouteStepItem/RouteStepBinding.dart';
import 'app_theme/app_theme.dart';
import 'app_theme/theme_controller.dart';
import 'helper/mapHelper/dart/MapHelper_Controller.dart';
import 'language/Language.dart';
import 'language/Language_Controller.dart';

// Import Bindings & Screens
import 'modules/ActiveDeliveryRoute/ActiveDeliveryRouteBinding.dart';
import 'modules/ActiveDeliveryRoute/ActiveDeliveryRoute_Screen.dart';
import 'modules/ActiveOptimizedRouteTracking/ActiveOptimizedRouteTrackingBinding.dart';
import 'modules/ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Screen.dart';
import 'modules/AddOrder/AddOrderBinding.dart';
import 'modules/AddOrder/AddOrder_Screen.dart';
import 'modules/AddPharmacy/AddPharmacyBinding.dart';
import 'modules/AddPharmacy/AddPharmacy_Screen.dart';
import 'modules/ChatGemini/ChatGemini_Screen.dart';
import 'modules/ConfirmDelivery/ConfirmDeliveryBinding.dart';
import 'modules/ConfirmDelivery/ConfirmDelivery_Screen.dart';
import 'modules/Home/HomeBinding.dart';
import 'modules/Home/Home_Screen.dart';
import 'modules/HomeContent/HomeContent_Screen.dart';
import 'modules/Notifications/NotificationsBinding.dart';
import 'modules/Notifications/Notifications_Screen.dart';
import 'modules/PlanYourRoute/PlanYourRouteBinding.dart';
import 'modules/PlanYourRoute/PlanYourRoute_Controller.dart';
import 'modules/PlanYourRoute/PlanYourRoute_Screen.dart';
import 'modules/PlanYourRoute/ReverbService.dart';
import 'modules/RePlanRoute/RePlanRoute_Screen.dart';
import 'modules/SignIn/SignInBinding.dart';
import 'modules/SignIn/SignIn_Screen.dart';
import 'modules/Splash/Splash_Screen.dart';
import 'modules/Tracking/LiveLocationTracker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => ReverbService().init());
  await GetStorage.init();
  await Firebase.initializeApp();
  await Notifications().initNotifications();
  Get.put(MapHelperController(), tag: "routeDelivery");
  Get.put(MapHelperController(), tag: "route");
  Get.put(MapHelperController(), tag: "addPharmacy");
  Get.put(MyLanguageController());
  final themeController = Get.put(ThemeController());
  Get.put(PlanYourRouteController(), permanent: true);
  Get.put(LiveLocationTracker(), permanent: true);

  // 🟢 تسجيل السلة بشكل دائم لتظل أدوية السلة محفوظة في كل التنقلات
  Get.put(NewOrderController(), permanent: true);

  themeController.loadThemeFromStorage();

  DioClient.init();

  final box = GetStorage();
  final token = box.read<String>('token');

  runApp(MyApp(initialRoute: token == null ? '/login' : '/homeScreen'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

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
          GetPage(name: '/splash', page: () => const SplashScreen()),

          GetPage(
            name: '/login',
            page: () => const SignInScreen(),
            binding: SignInBinding(),
          ),

          GetPage(
            name: '/homeScreen',
            page: () => HomeScreen(),
            binding: HomeBinding(),
          ),

          GetPage(
            name: '/activeDeliveryRoute',
            page: () => const ActiveDeliveryRouteScreen(),
            binding: ActiveDeliveryRouteBinding(),
          ),

          GetPage(
            name: '/activeOptimizedRouteTracking',
            page: () => const ActiveOptimizedRouteTrackingScreen(),
            bindings: [
              ActiveOptimizedRouteTrackingBinding(),
              RouteStepBinding(),
            ],
          ),

          GetPage(
            name: '/addOrder',
            page: () => AddOrderScreen(),
            binding: AddOrderBinding(),
          ),

          GetPage(
            name: '/addPharmacy',
            page: () => const AddPharmacyScreen(),
            binding: AddPharmacyBinding(),
          ),

          GetPage(
            name: '/chat',
            page: () => const ChatScreen(),
            binding: HomeBinding(),
          ),

          GetPage(
            name: '/confirmDelivery',
            page: () => const ConfirmDeliveryScreen(),
            binding: ConfirmDeliveryBinding(),
          ),

          GetPage(
            name: '/notifications',
            page: () => const NotificationsScreen(),
            binding: NotificationsBinding(),
          ),

          GetPage(
            name: '/planYourRoute',
            page: () => const PlanYourRouteScreen(),
            binding: PlanYourRouteBinding(),
          ),
          GetPage(
            name: '/rePlanRoute',
            page: () => const RePlanRouteScreen(),
            binding: RePlanRouteBinding(),
          ),
          GetPage(
            name: '/newOrderScreen',
            page: () => const NewOrderScreen(),
           // binding: NewOrderBinding(),
          ),
          GetPage(
            name: '/homeContentScreen',
            page: () => const HomeContentScreen(),
            binding: HomeBinding(),
          ),
        ],
      ),
    );
  }
}