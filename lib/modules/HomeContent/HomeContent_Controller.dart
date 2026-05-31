

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../services/ServiceApi/HomeService.dart';
import 'HomeContent_Model.dart';

class HomeContentController extends GetxController {
  final isLoading = false.obs;

  final statistics = Rxn<StatisticsModel>();

  final todayVisits = <TodayVisitModel>[].obs;

  @override
  void onInit() {
    getHomePage();
    super.onInit();
  }

  Future<void> getHomePage() async {
    try {
      isLoading.value = true;

      final response = await HomeService.getHomePage();
      final model = HomePageModel.fromJson(response);
      statistics.value = model.statistics;
      todayVisits.assignAll(model.todayVisits);
    } catch (e) {
      if (e is DioException) {
       /* print("STATUS CODE: ${e.response?.statusCode}");
        print("RESPONSE DATA: ${e.response?.data}");
        print("REQUEST PATH: ${e.requestOptions.path}");
        print("REQUEST HEADERS: ${e.requestOptions.headers}");*/
      } else {
        print(e);
      }

    } finally {
      isLoading.value = false;
    }
  }
}