import 'dart:async';
import 'package:flutter/foundation.dart';

/// PushNotificationService: chạy mà không cần Firebase.
/// Streams được HomeScreen lắng nghe để hiển thị overlay notification.
/// Khi tích hợp FCM sau này, chỉ cần thêm logic vào init().
class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._internal();

  factory PushNotificationService() => _instance;

  PushNotificationService._internal();

  final _foregroundController = StreamController<Map<String, dynamic>>.broadcast();
  final _tapController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get onForegroundMessage => _foregroundController.stream;
  Stream<Map<String, dynamic>> get onNotificationTap => _tapController.stream;

  Future<void> init() async {
    // Firebase Cloud Messaging is not configured yet.
    // This service acts as a stub so HomeScreen compiles and runs.
    // When FCM is set up, add firebase_core + firebase_messaging packages
    // and uncomment the FCM logic below.
    debugPrint('PushNotificationService: stub mode (Firebase not configured)');

    // --- Uncomment after running: flutterfire configure ---
    // try {
    //   await Firebase.initializeApp();
    //   final messaging = FirebaseMessaging.instance;
    //   await messaging.requestPermission(alert: true, badge: true, sound: true);
    //   FirebaseMessaging.onMessage.listen((msg) {
    //     _foregroundController.add(_normalize(msg));
    //   });
    //   FirebaseMessaging.onMessageOpenedApp.listen((msg) {
    //     _tapController.add(_normalize(msg));
    //   });
    //   final initial = await messaging.getInitialMessage();
    //   if (initial != null) _tapController.add(_normalize(initial));
    //   debugPrint('FCM token: ${await messaging.getToken()}');
    // } catch (e) {
    //   debugPrint('Firebase init skipped: $e');
    // }
  }

  /// Gọi từ bên ngoài (ví dụ: test) để giả lập push notification
  void simulatePush(Map<String, dynamic> data) {
    _foregroundController.add(data);
  }

  void dispose() {
    _foregroundController.close();
    _tapController.close();
  }
}
