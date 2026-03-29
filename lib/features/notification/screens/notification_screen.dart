import 'package:flutter/material.dart';
import '../../../widgets/gradient_background.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

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

    // Dummy notifications
    final notifications = [
      {
        'title': 'Cập nhật hệ thống',
        'content': 'Phiên bản mới v1.0.1 đã sẵn sàng tải xuống.',
        'time': 'Vừa xong',
        'icon': Icons.system_update,
        'color': Colors.blue,
      },
      {
        'title': 'Đăng nhập mới',
        'content': 'Phát hiện đăng nhập từ thiết bị mới lúc 15:30.',
        'time': '2 giờ trước',
        'icon': Icons.security,
        'color': Colors.orange,
      },
      {
        'title': 'Tin nhắn từ Hệ thống',
        'content': 'Chào mừng bạn đến với DEMO Messenger!',
        'time': '1 ngày trước',
        'icon': Icons.info,
        'color': Colors.green,
      },
    ];

    return GradientBackground(
      child: SafeArea(
        child: notifications.isEmpty
            ? Center(
                child: Text(
                  'Không có thông báo nào',
                  style: TextStyle(color: subtitleColor, fontSize: 16),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                itemCount: notifications.length,
                separatorBuilder: (context, index) => Divider(
                  color: dividerColor,
                  height: 24,
                ),
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (notif['color']! as Color).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          notif['icon']! as IconData,
                          color: notif['color']! as Color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    notif['title']! as String,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  notif['time']! as String,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notif['content']! as String,
                              style: TextStyle(
                                fontSize: 14,
                                color: subtitleColor,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
