import '../../modules/VisitDetails/VisitDetails_Model.dart';
import '../../services/ApiService.dart';

class VisitsService {
  static Future<void> checkVisit({
    required int visitId,
    required VisitCheckModel requestData,
  }) async {
    try {
      await ApiService.post(
        "/planner/v1/visits/$visitId/check",
        data: requestData.toJson(),
      );

      return;

    }  catch (e) {
      print("[General Service Error]: $e");
      rethrow;
    }
  }
}