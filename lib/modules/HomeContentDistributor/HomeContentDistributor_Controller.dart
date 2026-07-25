import 'package:get/get.dart';
import '../../services/ServiceApi/DeliveryHomeService.dart';
import 'HomeContentDistributor_Model.dart';

class DeliveryHomeController extends GetxController {
  var isLoading = true.obs;
  var homeData = Rxn<DeliveryHomeModel>();

  @override
  void onInit() {
    super.onInit();
    fetchDeliveryHome();
  }

  Future<void> fetchDeliveryHome({bool showLoading = true}) async {
    try {
      if (showLoading) isLoading(true);
      final responseMap = await DeliveryHomeService.getDeliveryHome();
      if (responseMap['isSuccess'] == true) {
        homeData.value = DeliveryHomeModel.fromJson(responseMap);
      }
    } catch (e) {
      print("Error fetching delivery home: $e");
    } finally {
      if (showLoading) isLoading(false);
    }
  }
}