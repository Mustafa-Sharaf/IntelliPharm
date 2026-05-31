
import 'package:get/get.dart';
import '../../modules/ActiveOptimizedRouteTracking/ActiveOptimizedRouteTracking_Model.dart';
import '../PlanYourRoute/PlanYourRoute_Controller.dart';


class ActiveOptimizedRouteTrackingController extends GetxController {
  final planYourRouteController = Get.find<PlanYourRouteController>();

  var isLoading = false.obs;
  late var plan = planYourRouteController.plan.value;
  var selectedRegion = ''.obs;


  PlanVisit? get nextVisit {
    if (plan== null || plan!.visits.isEmpty) {
      return null;
    }

    try {
      return plan!.visits.firstWhere((v) => !v.visited);
    } catch (_) {
      return plan!.visits.first;
    }
  }

}
