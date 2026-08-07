import 'package:get/get.dart';
import '../../Widgets/CustomBottomNav/CustomBottomNavController.dart';
import '../ActiveDeliveryRoute/ActiveDeliveryRoute_Controller.dart';
import '../ChatGemini/ChatGemini_Controller.dart';
import '../HomeContent/HomeContent_Controller.dart';
import '../HomeContentDistributor/HomeContentDistributor_Controller.dart';
import '../MyDeliveries/MyDeliveries_Controller.dart';
import '../MyOrders/MyOrders_Controller.dart';
import '../Pharmacists/Pharmacists_Controller.dart';
import '../PharmacyDebts/PharmacyDebt_Controller.dart';
import '../Searching/Searching_Controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // حقن كنترولر الشريط السفلي (Bottom Navigation)
    Get.lazyPut<CustomBottomNavController>(
          () => CustomBottomNavController(),
      fenix: true,
    );
    Get.lazyPut<HomeContentController>(
          () => HomeContentController(),
      fenix: true, // يضمن بقاءه متوفراً عند التنقل بين تبويبات HomeScreen
    );
    Get.lazyPut<ChatController>(
          () => ChatController(),
      fenix: true, // يضمن بقاءه متوفراً عند التنقل بين التبويبات
    );
    Get.lazyPut<MyOrdersController>(() => MyOrdersController(), fenix: true);
    Get.lazyPut<PharmacistsController>(
          () => PharmacistsController(),
      fenix: true,
    );

    Get.lazyPut<SearchControllerX>(
          () => SearchControllerX(),
    );
    Get.lazyPut<DeliveryHomeController>(
          () => DeliveryHomeController(),
      fenix: true,
    );

    Get.lazyPut<ActiveDeliveryRouteController>(
          () => ActiveDeliveryRouteController(),
      fenix: true,
    );
    Get.lazyPut<MyDeliveriesController>(
          () => MyDeliveriesController(),
      fenix: true,
    );
    Get.lazyPut<PharmacyDebtController>(
          () => PharmacyDebtController(),
      fenix: true,
    );
  }
}