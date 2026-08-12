/*
enum PaymentStatus { overdue, partial, paid, pending }

class PharmacyDebtModel {
  final String id;
  final String name;
  final String location;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final String lastPaymentDate;
  final PaymentStatus status;

  PharmacyDebtModel({
    required this.id,
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
    return PharmacyDebtModel(
      id: json['id']?.toString() ?? '',
      name: json['pharmacy_name'] ?? '',
      location: json['region_name'] ?? '',
      totalAmount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (json['paid_amount'] as num?)?.toDouble() ?? 0.0,
      remainingAmount: (json['remaining_amount'] as num?)?.toDouble() ?? 0.0,
      lastPaymentDate: json['last_payment'] ?? json['due_date'] ?? '',
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
*/
enum PaymentStatus { overdue, partial, paid, pending }

class PharmacyDebtModel {
  final String id;
  final String name;
  final String location;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final String lastPaymentDate;
  final PaymentStatus status;

  PharmacyDebtModel({
    required this.id,
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
    // 1. استخراج تاريخ الدفعة الأخيرة بأمان سواء كانت Map أو String أو null
    String parsedLastPayment = 'N/A';

    if (json['last_payment'] != null) {
      if (json['last_payment'] is Map) {
        // الاستخراج من الكائن المجوف
        parsedLastPayment = json['last_payment']['payment_date'] ??
            json['last_payment']['created_at'] ??
            'N/A';
      } else if (json['last_payment'] is String) {
        parsedLastPayment = json['last_payment'];
      }
    } else if (json['due_date'] != null) {
      // في حال عدم وجود دفعة سابقة يتم استخدام تاريخ الاستحقاق
      parsedLastPayment = json['due_date'].toString();
    }

    return PharmacyDebtModel(
      id: json['id']?.toString() ?? '',
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