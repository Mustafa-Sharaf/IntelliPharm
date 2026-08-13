
class RecordPaymentModel {
  final int pharmacyId;
  final double amount;
  final String paymentDate;
  final String note;

  RecordPaymentModel({
    required this.pharmacyId,
    required this.amount,
    required this.paymentDate,
    required this.note
  });

  Map<String, dynamic> toJson() {
    return {
      "pharmacy_id": pharmacyId,
      "amount": amount,
      "payment_date": paymentDate,
      "note":note
    };
  }
}