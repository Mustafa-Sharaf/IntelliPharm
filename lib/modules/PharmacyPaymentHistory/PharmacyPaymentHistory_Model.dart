import '../PharmacyDebts/PharmacyDebt_Model.dart';

class PaymentItemModel {
  final String id;
  final double amount;
  final String date;
  final String paymentMethod;
  final String ref;
  final String collectedBy;
  final double balanceAfter;

  PaymentItemModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.paymentMethod,
    required this.ref,
    required this.collectedBy,
    required this.balanceAfter,
  });

  factory PaymentItemModel.fromJson(Map<String, dynamic> json) {
    return PaymentItemModel(
      id: json['id']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date: json['payment_date'] ?? json['created_at'] ?? '',
      paymentMethod: 'CASH', // القيمة الافتراضية للدفعة
      ref: 'PAY-${json['id']}',
      collectedBy: json['collected_by_name'] ?? '',
      balanceAfter: (json['remaining_debt_snapshot'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class InvoiceItemModel {
  final String id;
  final String orderCode;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final String createdAt;
  final PaymentStatus status;

  InvoiceItemModel({
    required this.id,
    required this.orderCode,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.createdAt,
    required this.status,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) {
    return InvoiceItemModel(
      id: json['id']?.toString() ?? '',
      orderCode: 'ORD-${json['id']}',
      totalAmount: (json['final_total'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (json['paid_amount'] as num?)?.toDouble() ?? 0.0,
      remainingAmount: (json['remainingAmount'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] ?? '',
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

class PharmacyDebtDetailsResponse {
  final int debtId;
  final List<PaymentItemModel> payments;
  final List<InvoiceItemModel> invoices;

  PharmacyDebtDetailsResponse({
    required this.debtId,
    required this.payments,
    required this.invoices,
  });

  factory PharmacyDebtDetailsResponse.fromJson(Map<String, dynamic> json) {
    final List paymentsJson = json['payments'] ?? [];
    final List ordersJson = json['orders'] ?? [];

    return PharmacyDebtDetailsResponse(
      debtId: json['id'] ?? 0,
      payments: paymentsJson.map((e) => PaymentItemModel.fromJson(e)).toList(),
      invoices: ordersJson.map((e) => InvoiceItemModel.fromJson(e)).toList(),
    );
  }
}