

/*
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
       */
/* print("STATUS CODE: ${e.response?.statusCode}");
        print("RESPONSE DATA: ${e.response?.data}");
        print("REQUEST PATH: ${e.requestOptions.path}");
        print("REQUEST HEADERS: ${e.requestOptions.headers}");*//*

      } else {
        print(e);
      }

    } finally {
      isLoading.value = false;
    }
  }
}*/
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
    super.onInit();
    getHomePage();
  }

  // يتم استدعاؤها بمجرد تجهيز الشاشة وعرضها للمستخدم
  @override
  void onReady() {
    super.onReady();
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
      }
    } catch (e) {
      if (e is DioException) {
        // يمكنك طباعة الأخطاء للتأكد إذا كان التوكين UnAuthorized (401)
        print("Dio Error: ${e.response?.statusCode}");
      } else {
        print("Error: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }
}