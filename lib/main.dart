/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intellipharm/services/DioClient.dart';
import 'Notifications.dart';
import 'Widgets/PharmacySelector/PharmacyList_Controller.dart';
import 'app_theme/app_theme.dart';
import 'app_theme/theme_controller.dart';
import 'helper/mapHelper/dart/MapHelper_Controller.dart';
import 'language/Language.dart';
import 'language/Language_Controller.dart';
import 'modules/ActiveDeliveryRoute/ActiveDeliveryRouteBinding.dart';
import 'modules/ActiveDeliveryRoute/ActiveDeliveryRoute_Screen.dart';
import 'modules/ActiveOptimizedRouteTracking/ActiveOptimizedRouteTrackingBinding.dart';
import 'modules/ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Controller.dart';
import 'modules/ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Screen.dart';
import 'modules/AddOrder/AddOrderBinding.dart';
import 'modules/AddOrder/AddOrder_Controller.dart';
import 'modules/AddOrder/AddOrder_Screen.dart';
import 'modules/AddPharmacy/AddPharmacyBinding.dart';
import 'modules/AddPharmacy/AddPharmacy_Controller.dart';
import 'modules/AddPharmacy/AddPharmacy_Screen.dart';
import 'modules/ChatGemini/ChatBinding.dart';
import 'modules/ChatGemini/ChatGemini_Screen.dart';
import 'modules/ConfirmDelivery/ConfirmDeliveryBinding.dart';
import 'modules/ConfirmDelivery/ConfirmDelivery_Screen.dart';
import 'modules/Home/HomeBinding.dart';
import 'modules/Home/Home_Screen.dart';
import 'modules/HomeContent/HomeContent_Controller.dart';
import 'modules/MyOrders/MyOrders_Controller.dart';
import 'modules/NewOrder/NewOrder_Controller.dart';
import 'modules/Notifications/NotificationsBinding.dart';
import 'modules/Notifications/Notifications_Screen.dart';
import 'modules/PlanYourRoute/PlanYourRouteBinding.dart';
import 'modules/PlanYourRoute/PlanYourRoute_Controller.dart';
import 'modules/PlanYourRoute/PlanYourRoute_Screen.dart';
import 'modules/SignIn/SignInBinding.dart';
import 'modules/SignIn/SignIn_Screen.dart';
import 'modules/Splash/Splash_Screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  await Notifications().initNotifications();
  Get.put(MyLanguageController());
  DioClient.init();

  Get.put(MapHelperController(), tag: "route");
  Get.put(MapHelperController(), tag: "addPharmacy");
  final themeController = Get.put(ThemeController());
  Get.put(PlanYourRouteController());
  Get.put(AddOrderController());
  Get.put(HomeContentController());
  Get.put(PharmacySelectorController(), permanent: true);
  Get.put(NewOrderController(), permanent: true);
  Get.put(MyOrdersController());
  Get.put(ActiveOptimizedRouteTrackingController());
  Get.put(AddPharmacyController());
  themeController.loadThemeFromStorage();
  final box = GetStorage();
  final token = box.read<String>('token');
  runApp(MyApp(initialRoute: token == null ? '/splash' : '/homeScreen'));
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
          GetPage(name: '/splash', page: () => SplashScreen()),
         // GetPage(name: '/signIn', page: () => SignInScreen()),
          //GetPage(name: '/homeScreen', page: () => HomeScreen()),

          GetPage(
            name: '/activeDeliveryRoute',
            page: () => const ActiveDeliveryRouteScreen(),
            binding: ActiveDeliveryRouteBinding(),
          ),

          GetPage(
            name: '/activeOptimizedRouteTracking',
            page: () => const ActiveOptimizedRouteTrackingScreen(),
            binding: ActiveOptimizedRouteTrackingBinding(),
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
            binding: ChatBinding(),
          ),

          GetPage(
            name: '/confirmDelivery',
            page: () => const ConfirmDeliveryScreen(),
            binding: ConfirmDeliveryBinding(),
          ),

          GetPage(
            name: '/home',
            page: () => HomeScreen(),
            binding: HomeBinding(),
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
        name: '/login',
        page: () => const SignInScreen(),
        binding: SignInBinding(),
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
import 'package:intellipharm/modules/HomeContent/HomeContentBinding.dart';
import 'package:intellipharm/modules/NewOrder/NewOrderBinding.dart';
import 'package:intellipharm/modules/NewOrder/NewOrder_Screen.dart';
import 'package:intellipharm/modules/RePlanRoute/RePlanRouteBinding.dart';
import 'package:intellipharm/services/DioClient.dart';
import 'Notifications.dart';
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
import 'modules/ChatGemini/ChatBinding.dart';
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
import 'modules/RePlanRoute/RePlanRoute_Screen.dart';
import 'modules/SignIn/SignInBinding.dart';
import 'modules/SignIn/SignIn_Screen.dart';
import 'modules/Splash/Splash_Screen.dart';
import 'modules/Tracking/LiveLocationTracker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  await Notifications().initNotifications();

  Get.put(MapHelperController(), tag: "route");
  Get.put(MapHelperController(), tag: "addPharmacy");
  Get.put(MyLanguageController());
  final themeController = Get.put(ThemeController());
  Get.put(PlanYourRouteController(), permanent: true);
  Get.put(LiveLocationTracker(), permanent: true);
  themeController.loadThemeFromStorage();

  // 🟢 2. تهيئة خدمات الشباك والـ Network
  DioClient.init();

  // 🔴 ملاحظة: تم إزالة الكنترولرات الخاصة بالشاشات الفرعية
  // (PlanYourRouteController, AddOrderController, AddPharmacyController, ActiveOptimizedRouteTrackingController ...)
  // لأنها أصبحت تُحقن وتُحذف عبر الـ Bindings الخاصة بكل شاشة تلقائياً.

  final box = GetStorage();
  final token = box.read<String>('token');

  runApp(MyApp(initialRoute: token == null ? '/splash' : '/homeScreen'));
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
            binding: ActiveOptimizedRouteTrackingBinding(),
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
