enum PaymentStatus { overdue, partial, paid }

class PharmacyDebtModel {
  final String id;
  final String name;
  final String location;
  final double totalAmount;
  final double paidAmount;
  final String lastPaymentDate;
  final PaymentStatus status;

  PharmacyDebtModel({
    required this.id,
    required this.name,
    required this.location,
    required this.totalAmount,
    required this.paidAmount,
    required this.lastPaymentDate,
    required this.status,
  });

  double get remainingAmount => totalAmount - paidAmount;
  double get paidPercentage => (paidAmount / totalAmount).clamp(0.0, 1.0);

  // جاهز للربط مستقبلاً مع JSON
  factory PharmacyDebtModel.fromJson(Map<String, dynamic> json) {
    return PharmacyDebtModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paidAmount: (json['paidAmount'] as num).toDouble(),
      lastPaymentDate: json['lastPaymentDate'] ?? '',
      status: _parseStatus(json['status']),
    );
  }

  static PaymentStatus _parseStatus(String? statusStr) {
    switch (statusStr?.toLowerCase()) {
      case 'overdue':
        return PaymentStatus.overdue;
      case 'partial':
        return PaymentStatus.partial;
      case 'paid':
        return PaymentStatus.paid;
      default:
        return PaymentStatus.overdue;
    }
  }
}