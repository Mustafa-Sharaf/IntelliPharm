import '../../modules/Payments/RecordPayment_Model.dart';
import '../ApiService.dart';


class RecordPaymentService {
  static Future createPayment(RecordPaymentModel requestData) async {
    final response = await ApiService.post(
      "/erp/v1/payments",
      data: requestData.toJson(),
    );

    return response.data;
  }
}