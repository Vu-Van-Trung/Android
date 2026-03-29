import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import '../services/auth_service.dart';
import '../features/contacts/screens/contacts_screen.dart';
import '../features/account/screens/account_screen.dart';
import '../features/chat/screens/chat_list_screen.dart';
import '../features/chat/screens/chat_detail_screen.dart';
import '../features/chat/models/conversation_model.dart';
import '../features/contacts/models/contact_model.dart';
import '../features/notification/screens/notification_screen.dart';
import '../services/socket_service.dart';
import '../services/api_client.dart';
import '../services/push_notification_service.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  final AuthService authService;

  const HomeScreen({super.key, required this.authService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  StreamSubscription<Map<String, dynamic>>? _socketSubscription;
  StreamSubscription<Map<String, dynamic>>? _fcmForegroundSubscription;
  StreamSubscription<Map<String, dynamic>>? _fcmTapSubscription;

  @override
  void initState() {
    super.initState();
    SocketService().connect();
    _socketSubscription = SocketService().onMessage.listen(_handleIncomingMessage);
    _fcmForegroundSubscription = PushNotificationService().onForegroundMessage.listen(_handleIncomingMessage);
    _fcmTapSubscription = PushNotificationService().onNotificationTap.listen(_openConversationFromPayload);
  }

  @override
  void dispose() {
    _socketSubscription?.cancel();
    _fcmForegroundSubscription?.cancel();
    _fcmTapSubscription?.cancel();
    SocketService().disconnect();
    super.dispose();
  }

  void _handleIncomingMessage(Map<String, dynamic> data) {
    final myUserId = ApiClient().userId;
    final senderId = (data['sender_id'] ?? data['sender'])?.toString();
    final conversationId = data['conversation_id']?.toString();

    // Skip socket echo from myself to avoid duplicate banner.
    if (myUserId != null && senderId == myUserId) {
      return;
    }

    // Skip banner while user is opening this exact conversation.
    if (conversationId != null && SocketService().currentChatId == conversationId) {
      return;
    }

    final senderName = (data['sender_name'] ?? data['senderName'] ?? senderId ?? 'Người dùng').toString();
    final text = (data['content'] ?? data['text'] ?? 'Có một tin nhắn mới').toString();

    showOverlayNotification(
      (overlayContext) {
        return SafeArea(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                OverlaySupportEntry.of(overlayContext)?.dismiss();
                _openConversationFromPayload(data);
              },
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF667EEA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.message, color: Colors.white),
                  title: Text(
                    'Tin nhắn mới từ $senderName',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.9)),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      duration: const Duration(seconds: 3),
      position: NotificationPosition.top,
    );
  }

  void _openConversationFromPayload(Map<String, dynamic> data) {
    final conversationId = data['conversation_id']?.toString();
    if (conversationId == null || !mounted) {
      return;
    }

    final senderId = (data['sender_id'] ?? data['sender'])?.toString();
    final senderName = (data['sender_name'] ?? data['senderName'] ?? senderId ?? 'Người dùng').toString();

    final conversation = Conversation(
      id: conversationId,
      partner: Contact(
        id: senderId ?? 'unknown_sender',
        name: senderName,
        phoneNumber: '',
        isOnline: true,
      ),
      messages: const [],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetailScreen(conversation: conversation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBackgroundColor = isDark ? const Color(0xFF1A1A2E) : const Color(0xFFFFFFFF);
    final unselectedColor = isDark ? const Color.fromRGBO(255, 255, 255, 0.6) : const Color.fromRGBO(0, 0, 0, 0.5);
    final appBarTitleColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(), style: TextStyle(color: appBarTitleColor)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const ChatListScreen(),
          const ContactsScreen(),
          const NotificationScreen(),
          AccountScreen(authService: widget.authService),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: navBackgroundColor,
        selectedItemColor: const Color(0xFF667EEA),
        unselectedItemColor: unselectedColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Tin nhắn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Danh bạ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Thông báo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Tin nhắn';
      case 1:
        return 'Danh bạ';
      case 2:
        return 'Thông báo';
      case 3:
        return 'Tài khoản';
      default:
        return 'DEMO Messenger';
    }
  }
}
