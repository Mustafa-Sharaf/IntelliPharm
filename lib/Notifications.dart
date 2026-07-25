import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  print("Background message received!");
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
}

class Notifications {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    playSound: true,
  );

  Future<void> initNotifications() async {
    try {
      await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      final token = await firebaseMessaging.getToken();
      print("Notification Token: $token");
      if (token != null) {
        GetStorage().write('fcm_token', token);
      }

      firebaseMessaging.onTokenRefresh.listen((newToken) {
        print("Notification Token Refreshed: $newToken");
        GetStorage().write('fcm_token', newToken);
      });

      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      // ✅ التعديل هنا: جلب تطبيق الأندرويد وإنشاء القناة
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        await androidImplementation.createNotificationChannel(channel);
      }

      FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("Foreground message received!");
        print("Title: ${message.notification?.title}");
        print("Body: ${message.notification?.body}");
        _showLocalNotification(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("🖱️ Notification clicked from background!");
        print("Title: ${message.notification?.title}");
        print("Body: ${message.notification?.body}");
      });

      RemoteMessage? initialMessage = await firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        print("🚀 App opened from terminated state via notification!");
        print("Title: ${initialMessage.notification?.title}");
        print("Body: ${initialMessage.notification?.body}");
      }

    } catch (e) {
      print("Failed to init notifications: $e");
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    NotificationDetails platformDetails =
    NotificationDetails(android: androidDetails);

    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? message.data['title'] ?? "Notification",
      message.notification?.body ?? message.data['body'] ?? "",
      platformDetails,
    );
  }
}