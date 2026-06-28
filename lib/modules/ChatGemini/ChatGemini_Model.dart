class ChatMessageModel {
  final int? id;
  final int? conversationId;
  final String role;
  final String message;
  final DateTime? createdAt;
  bool isLoading;

  ChatMessageModel({
    this.id,
    this.conversationId,
    required this.role,
    required this.message,
    this.createdAt,
    this.isLoading = false,
  });

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

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'role': role,
      'conversation_id': conversationId,
    };
  }
}