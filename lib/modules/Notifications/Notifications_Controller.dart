import 'package:get/get.dart';
import '../../services/ServiceApi/NotificationsService.dart';
import 'notifications_model.dart';

class NotificationsController extends GetxController {
  var isLoading = false.obs;
  var groupedNotifications = <NotificationGroup>[].obs;

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  Future<void> fetchNotifications({int page = 1}) async {
    try {
      isLoading(true);

      final responseData = await NotificationService.getNotifications(page: page);

      if (responseData != null && responseData['isSuccess'] == true) {
        final List rawList = responseData['data']['data'] ?? [];

        // 1. تحويل البيانات إلى Objects
        final allNotifications = rawList.map((e) => NotificationItem.fromJson(e)).toList();

        // 2. تصفية الإشعارات غير المقروءة فقط (isRead == false)
        final unreadNotifications = allNotifications.where((item) => !item.isRead).toList();

        // 3. تجميع الإشعارات غير المقروءة حسب التاريخ
        groupedNotifications.value = _groupNotificationsByDate(unreadNotifications);
      } else {
        groupedNotifications.clear();
      }
    } catch (e) {
      print("Error fetching notifications: $e");
      groupedNotifications.clear();
    } finally {
      isLoading(false);
    }
  }

  // دالة تجميع الإشعارات حسب التاريخ
  List<NotificationGroup> _groupNotificationsByDate(List<NotificationItem> items) {
    final Map<String, List<NotificationItem>> groupedMap = {};

    for (var item in items) {
      final dateKey = "${item.createdAt.day}-${item.createdAt.month}-${item.createdAt.year}";
      if (!groupedMap.containsKey(dateKey)) {
        groupedMap[dateKey] = [];
      }
      groupedMap[dateKey]!.add(item);
    }

    return groupedMap.entries
        .map((entry) => NotificationGroup(dateHeader: entry.key, items: entry.value))
        .toList();
  }
}