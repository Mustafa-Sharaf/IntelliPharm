


import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../services/ServiceApi/HomeService.dart';
import 'HomeContent_Model.dart';
class HomeContentController extends GetxController {
  final isLoading = false.obs;
  final statistics = Rxn<StatisticsModel>();
  final todayVisits = <TodayVisitModel>[].obs;
  final activeOffers = <ActiveOfferModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getHomePage();
  }


  Future<void> getHomePage() async {
    try {
      isLoading.value = true;
      final response = await HomeService.getHomePage();

      if (response != null) {
        final model = HomePageModel.fromJson(response);
        statistics.value = model.statistics;
        todayVisits.assignAll(model.todayVisits);
        activeOffers.assignAll(model.activeOffers);
      }
    } catch (e) {
      if (e is DioException) {

        print("Dio Error: ${e.response?.statusCode}");
      } else {
        print("Error: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }
}