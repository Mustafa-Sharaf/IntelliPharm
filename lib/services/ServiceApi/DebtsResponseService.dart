import '../../modules/PharmacyDebts/PharmacyDebt_Model.dart';
import '../ApiService.dart';


class DebtsResponseService {
  final List<PharmacyDebtModel> debts;
  final double totalDebtAmount;
  final double totalPaid;
  final double totalRemaining;

  DebtsResponseService({
    required this.debts,
    required this.totalDebtAmount,
    required this.totalPaid,
    required this.totalRemaining,
  });
}

class DebtsService {
  static Future<DebtsResponseService> getDebts({int page = 1, int perPage = 15}) async {
    final response = await ApiService.get(
      "/erp/v1/debts",
      query: {
        "per_page": perPage,
        "page_number": page,
      },
    );

    if (response.data["isSuccess"] == true) {
      final data = response.data["data"];
      final List debtsList = data["debts"] ?? [];
      final summary = data["summary"] ?? {};

      return DebtsResponseService(
        debts: debtsList.map((e) => PharmacyDebtModel.fromJson(e)).toList(),
        totalDebtAmount: (summary["total_debt_amount"] as num?)?.toDouble() ?? 0.0,
        totalPaid: (summary["total_paid"] as num?)?.toDouble() ?? 0.0,
        totalRemaining: (summary["total_remaining"] as num?)?.toDouble() ?? 0.0,
      );
    } else {
      throw Exception(response.data["message"] ?? "Failed to load debts");
    }
  }
}