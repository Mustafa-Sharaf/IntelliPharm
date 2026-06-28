import '../ApiService.dart';

class ChatService {
  static Future<Map<String, dynamic>?> sendMessage({
    required String message,
    int? conversationId,
  }) async {
    try {
      final response = await ApiService.post(
        "/llm/v1/gemini/messages",
        data: {
          "message": message,
          "role": "user",
          "conversation_id": conversationId,
        },
      );

      if (response.data != null) {
        return response.data;
      }
      return null;
    } catch (e) {
      print("Error in ChatService: $e");
      return null;
    }
  }
}