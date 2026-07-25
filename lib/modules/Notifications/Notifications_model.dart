class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? '',
      isRead: json['read_at'] != null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class NotificationGroup {
  final String dateHeader;
  final List<NotificationItem> items;

  NotificationGroup({
    required this.dateHeader,
    required this.items,
  });
}