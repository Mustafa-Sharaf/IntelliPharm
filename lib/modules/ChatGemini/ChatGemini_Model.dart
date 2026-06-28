class ChatMessageModel {
  final int? id;
  final int? conversationId;
  final String role;
  final String message;
  final DateTime? createdAt;

  // حقل إضافي للتحكم بحالة التحميل لكل رسالة بشكل مستقل إذا لزم الأمر
  bool isLoading;

  ChatMessageModel({
    this.id,
    this.conversationId,
    required this.role,
    required this.message,
    this.createdAt,
    this.isLoading = false,
  });

  // التحويل من JSON القادم من الـ API
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      conversationId: json['conversation_id'],
      role: json['role'] ?? 'model',
      message: json['message'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  // التحويل إلى JSON لإرساله في الـ Request
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'role': role,
      'conversation_id': conversationId,
    };
  }
}