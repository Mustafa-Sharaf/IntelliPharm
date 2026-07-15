import 'package:get/get.dart';

import '../../services/ServiceApi/DeliveryHomeService.dart';
import 'HomeContentDistributor_Model.dart';

class DeliveryHomeController extends GetxController {
  var isLoading = true.obs;
  var homeData = Rxn<DeliveryHomeModel>();

  @override
  void onInit() {
    fetchDeliveryHome();
    super.onInit();
  }

  Future<void> fetchDeliveryHome() async {
    try {
      isLoading(true);
      final responseMap = await DeliveryHomeService.getDeliveryHome();
      if (responseMap['isSuccess'] == true) {
        homeData.value = DeliveryHomeModel.fromJson(responseMap);
      }
    } catch (e) {
      print("Error fetching delivery home: $e");
    } finally {
      isLoading(false);
    }
  }
}