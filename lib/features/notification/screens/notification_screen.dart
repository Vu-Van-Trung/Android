import 'dart:async';
import 'package:flutter/material.dart';
import '../../../widgets/gradient_background.dart';
import '../../../services/socket_service.dart';

class _NotifItem {
  final String title;
  final String content;
  final DateTime time;
  final IconData icon;
  final Color color;
  final String? conversationId;

  _NotifItem({
    required this.title,
    required this.content,
    required this.time,
    required this.icon,
    required this.color,
    this.conversationId,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<_NotifItem> _notifications = [
    _NotifItem(
      title: 'Chào mừng!',
      content: 'Đã đăng nhập thành công vào DEMO Messenger.',
      time: DateTime.now().subtract(const Duration(minutes: 5)),
      icon: Icons.waving_hand,
      color: Colors.green,
    ),
  ];

  StreamSubscription<Map<String, dynamic>>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = SocketService().onMessage.listen(_onSocketMessage);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _onSocketMessage(Map<String, dynamic> data) {
    final senderId = (data['sender_id'] ?? data['sender'])?.toString();
    final senderName = (data['sender_name'] ?? data['senderName'] ?? senderId ?? 'Người dùng').toString();
    final text = (data['content'] ?? data['text'] ?? '').toString();
    final convId = data['conversation_id']?.toString();

    if (text.isEmpty) return;

    if (mounted) {
      setState(() {
        _notifications.insert(
          0,
          _NotifItem(
            title: 'Tin nhắn từ $senderName',
            content: text,
            time: DateTime.now(),
            icon: Icons.message_rounded,
            color: const Color(0xFF667EEA),
            conversationId: convId,
          ),
        );
      });
    }
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inSeconds < 60) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark
        ? const Color.fromRGBO(255, 255, 255, 0.6)
        : const Color.fromRGBO(0, 0, 0, 0.6);
    final dividerColor = isDark
        ? const Color.fromRGBO(255, 255, 255, 0.08)
        : const Color.fromRGBO(0, 0, 0, 0.08);

    return GradientBackground(
      child: SafeArea(
        child: Column(
          children: [
            // Header with clear button
            if (_notifications.length > 1)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _notifications.removeWhere((n) => n.conversationId != null);
                        });
                      },
                      icon: const Icon(Icons.delete_sweep_outlined, size: 18),
                      label: const Text('Xoá tin nhắn'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color.fromRGBO(255, 255, 255, 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: _notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none_rounded,
                            size: 72,
                            color: subtitleColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Chưa có thông báo nào',
                            style: TextStyle(color: subtitleColor, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      itemCount: _notifications.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: dividerColor, height: 20),
                      itemBuilder: (context, index) {
                        final notif = _notifications[index];
                        return Dismissible(
                          key: ValueKey('$index-${notif.time.millisecondsSinceEpoch}'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.delete_outline, color: Colors.white),
                          ),
                          onDismissed: (_) {
                            setState(() => _notifications.removeAt(index));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: notif.color.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(notif.icon, color: notif.color, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            notif.title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              color: textColor,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _formatTime(notif.time),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: subtitleColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      notif.content,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: subtitleColor,
                                        height: 1.4,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
