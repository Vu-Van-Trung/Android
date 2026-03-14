import 'package:flutter/material.dart';
import '../models/conversation_model.dart';

class ChatListItem extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays == 0 && now.day == time.day) {
      // Same day: show time "HH:mm"
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays < 7) {
      // Within a week: show weekday name
      const weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
      // time.weekday is 1-7 (Mon-Sun)
      return weekdays[time.weekday - 1];
    } else {
      // Older: show date "dd/MM"
      return '${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final lastMessage = conversation.lastMessage;
    // Check if the message is unread (only for received messages)
    final hasUnread = conversation.unreadCount > 0;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: const Color.fromRGBO(102, 126, 234, 0.15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color.fromRGBO(255, 255, 255, 0.1),
            ),
          ),
          child: Row(
            children: [
              // Avatar with Online Indicator
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFF667EEA).withValues(alpha: 0.3),
                    backgroundImage: conversation.partner.avatarUrl != null
                        ? NetworkImage(conversation.partner.avatarUrl!)
                        : null,
                    child: conversation.partner.avatarUrl == null
                        ? Text(
                            conversation.partner.name[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  if (conversation.partner.isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ECDC4),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF1A1A2E), // Match background to cut out
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Message Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Time row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            conversation.partner.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  hasUnread ? FontWeight.bold : FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (lastMessage != null)
                          Text(
                            _formatTime(lastMessage.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                              color: hasUnread
                                  ? const Color(0xFF667EEA)
                                  : const Color.fromRGBO(255, 255, 255, 0.5),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Last Message and Unread Badge
                    Row(
                      children: [
                        Expanded(
                          child: lastMessage != null
                              ? Text(
                                  (lastMessage.isSender ? 'Bạn: ' : '') +
                                      lastMessage.text,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: hasUnread
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: hasUnread
                                        ? Colors.white
                                        : const Color.fromRGBO(
                                            255, 255, 255, 0.6),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : const Text(
                                  'Chưa có tin nhắn',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Color.fromRGBO(255, 255, 255, 0.4),
                                  ),
                                ),
                        ),
                        if (hasUnread) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF667EEA),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              conversation.unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
