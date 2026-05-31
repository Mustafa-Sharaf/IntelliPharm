/*
import '../../modules/Pharmacists/Pharmacists_Model.dart';
import '../ApiService.dart';

class PharmaciesService {
  static Future<List<PharmaciesModel>> getPharmacies(int id) async {
    final response = await ApiService.get(
      "/erp/v1/pharmacies",
      query: {"region": id},
    );

    if (response.data["isSuccess"] == true) {
      List data = response.data["data"]["data"];

      return data.map((e) => PharmaciesModel.fromJson(e)).toList();
    } else {
      throw Exception(response.data["message"]);
    }
  }
}*/
import '../../modules/Pharmacists/Pharmacists_Model.dart';
import '../ApiService.dart';

class PharmaciesResponse {
  final List<PharmaciesModel> pharmacies;
  final int currentPage;
  final int lastPage;
  PharmaciesResponse({
    required this.pharmacies,
    required this.currentPage,
    required this.lastPage,
  });
}

class PharmaciesService {
  static Future<PharmaciesResponse> getPharmacies(
    int regionId,
    int page,
  ) async {
    final response = await ApiService.get(
      "/erp/v1/pharmacies",
      query: {"region": regionId, "page_number": page},
    );
    if (response.data["isSuccess"] == true) {
      List data = response.data["data"]["data"];
      return PharmaciesResponse(
        pharmacies: data.map((e) => PharmaciesModel.fromJson(e)).toList(),
        currentPage: response.data["data"]["meta"]["current_page"],
        lastPage: response.data["data"]["meta"]["last_page"],
      );
    } else {
      throw Exception(response.data["message"]);
    }
  }
}
