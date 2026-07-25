import '../ApiService.dart';

class NotificationService {
  static Future getNotifications({required int page}) async {
    final response = await ApiService.get(
      "/auth/v1/notifications",
      query: {
        "page_number": page,
        "unread_only": true,
      },
    );

    return response.data;
  }
}