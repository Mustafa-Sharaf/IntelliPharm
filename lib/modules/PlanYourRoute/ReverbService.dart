import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class ReverbService extends GetxService {
  final _pusher = PusherChannelsFlutter.getInstance();
  bool _isConnected = false;
  final box = GetStorage();

  static const String reverbAppKey = '2qfzwkhjligzzadz2yc6';
  static const String apiBaseUrl = 'https://api.intelli-pharma.limebyte.org';

  Future<ReverbService> init() async {
    try {
      await _pusher.init(
        apiKey: reverbAppKey,
        cluster: 'mt1',
        authEndpoint: '$apiBaseUrl/broadcasting/auth',
        onAuthorizer: (channelName, socketId, options) async {
          final token = box.read<String>('token');

          final res = await GetConnect().post(
            '$apiBaseUrl/broadcasting/auth',
            'socket_id=$socketId&channel_name=$channelName',
            contentType: 'application/x-www-form-urlencoded',
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          );

          if (res.body is Map) {
            return Map<String, dynamic>.from(res.body as Map);
          } else if (res.body is String) {
            return jsonDecode(res.body as String) as Map<String, dynamic>;
          }
          return {};
        },
      );

      await _pusher.connect();
      _isConnected = true;
      print("🟢 Connected to Reverb Websocket");
    } catch (e) {
      print("❌ Reverb Init Error: $e");
    }
    return this;
  }

  Future<void> subscribe({
    required String channel,
    required void Function(String event, Map<String, dynamic> payload) onEvent,
  }) async {
    if (!_isConnected) await init();

    print("📡 Subscribing to channel: $channel");

    await _pusher.subscribe(
      channelName: channel,
      onEvent: (event) {
        if (event.eventName == 'pusher:subscription_succeeded') {
          print("✅ Subscribed successfully to $channel");
          return;
        }

        final rawData = event.data;
        if (rawData == null) return;

        final payload = rawData is String
            ? jsonDecode(rawData) as Map<String, dynamic>
            : Map<String, dynamic>.from(rawData as Map);

        onEvent(event.eventName, payload);
      },
    );
  }

  Future<void> unsubscribe(String channel) async {
    await _pusher.unsubscribe(channelName: channel);
  }
}
