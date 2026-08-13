
class RecordPaymentModel {
  final int pharmacyId;
  final double amount;
  final String paymentDate;

  RecordPaymentModel({
    required this.pharmacyId,
    required this.amount,
    required this.paymentDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "pharmacy_id": pharmacyId,
      "amount": amount,
      "payment_date": paymentDate,
    };
  }
}