
enum PaymentStatus { overdue, partial, paid, pending }

class PharmacyDebtModel {
  final String id;
  final int pharmacyId;
  final String name;
  final String location;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final String lastPaymentDate;
  final PaymentStatus status;

  PharmacyDebtModel({
    required this.id,
    required this.pharmacyId,
    required this.name,
    required this.location,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.lastPaymentDate,
    required this.status,
  });

  double get paidPercentage =>
      totalAmount == 0 ? 0 : (paidAmount / totalAmount).clamp(0.0, 1.0);

  factory PharmacyDebtModel.fromJson(Map<String, dynamic> json) {
    String parsedLastPayment = 'N/A';

    if (json['last_payment'] != null) {
      if (json['last_payment'] is Map) {
        parsedLastPayment = json['last_payment']['payment_date'] ??
            json['last_payment']['created_at'] ??
            'N/A';
      } else if (json['last_payment'] is String) {
        parsedLastPayment = json['last_payment'];
      }
    } else if (json['due_date'] != null) {
      parsedLastPayment = json['due_date'].toString();
    }

    return PharmacyDebtModel(
      id: json['id']?.toString() ?? '',
      pharmacyId: json['pharmacy_id'] ?? 0,
      name: json['pharmacy_name'] ?? '',
      location: json['region_name'] ?? '',
      totalAmount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (json['paid_amount'] as num?)?.toDouble() ?? 0.0,
      remainingAmount: (json['remaining_amount'] as num?)?.toDouble() ?? 0.0,
      lastPaymentDate: parsedLastPayment,
      status: _parseStatus(json['status']),
    );
  }

  static PaymentStatus _parseStatus(String? statusStr) {
    switch (statusStr?.toLowerCase()) {
      case 'paid':
        return PaymentStatus.paid;
      case 'partial':
      case 'partially_paid':
        return PaymentStatus.partial;
      case 'pending':
        return PaymentStatus.pending;
      case 'overdue':
      default:
        return PaymentStatus.overdue;
    }
  }
}