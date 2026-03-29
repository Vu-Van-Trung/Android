import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    debugPrint('Background FCM: ${message.messageId}');
  } catch (e) {
    debugPrint('Background FCM init skipped: $e');
  }
}

class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._internal();

  factory PushNotificationService() => _instance;

  PushNotificationService._internal();

  bool _initialized = false;

  final _foregroundController = StreamController<Map<String, dynamic>>.broadcast();
  final _tapController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get onForegroundMessage => _foregroundController.stream;
  Stream<Map<String, dynamic>> get onNotificationTap => _tapController.stream;

  Future<void> init() async {
    if (_initialized) return;

    try {
      await Firebase.initializeApp();
    } catch (e) {
      // Firebase config is optional at this stage; app continues without FCM.
      debugPrint('Firebase is not configured yet: $e');
      return;
    }

    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    debugPrint('FCM permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((message) {
      _foregroundController.add(_normalizeMessage(message));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _tapController.add(_normalizeMessage(message));
    });

    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _tapController.add(_normalizeMessage(initialMessage));
    }

    final token = await messaging.getToken();
    debugPrint('FCM token: $token');

    _initialized = true;
  }

  Map<String, dynamic> _normalizeMessage(RemoteMessage message) {
    final data = Map<String, dynamic>.from(message.data);

    data['conversation_id'] ??= data['conversationId'];
    data['sender_id'] ??= data['senderId'];
    data['sender_name'] ??= data['senderName'];
    data['content'] ??= data['text'] ?? message.notification?.body;
    data['title'] ??= message.notification?.title;

    return data;
  }
}

