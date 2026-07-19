class DeliveryConfirmationResponse {
  final bool isSuccess;
  final String message;
  final ConfirmationData? data;

  DeliveryConfirmationResponse({
    required this.isSuccess,
    required this.message,
    this.data,
  });

  factory DeliveryConfirmationResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryConfirmationResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ConfirmationData.fromJson(json['data']) : null,
    );
  }
}

class ConfirmationData {
  final int id;
  final int deliveryId;
  final String checkNotes;
  final String paymentAmount;
  final String receiverName;
  final String receiptImage;
  final String deliveryStatus;
  final String paymentStatus;
  final String createdAt;

  ConfirmationData({
    required this.id,
    required this.deliveryId,
    required this.checkNotes,
    required this.paymentAmount,
    required this.receiverName,
    required this.receiptImage,
    required this.deliveryStatus,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory ConfirmationData.fromJson(Map<String, dynamic> json) {
    return ConfirmationData(
      id: json['id'] ?? 0,
      deliveryId: json['delivery_id'] ?? 0,
      checkNotes: json['check_notes'] ?? '',
      paymentAmount: json['payment_amount'] ?? '0.00',
      receiverName: json['receiver_name'] ?? '',
      receiptImage: json['receipt_image'] ?? '',
      deliveryStatus: json['delivery_status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}