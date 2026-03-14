import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../../contacts/models/contact_model.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final Contact partner;

  const MessageBubble({
    super.key,
    required this.message,
    required this.partner,
  });

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isMe = message.isSender;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF667EEA).withValues(alpha: 0.3),
              backgroundImage: partner.avatarUrl != null
                  ? NetworkImage(partner.avatarUrl!)
                  : null,
              child: partner.avatarUrl == null
                  ? Text(
                      partner.name[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe
                    ? const Color(0xFF667EEA)
                    : const Color.fromRGBO(255, 255, 255, 0.1),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isMe ? const Radius.circular(20) : Radius.zero,
                  bottomRight: isMe ? Radius.zero : const Radius.circular(20),
                ),
                border: isMe
                    ? null
                    : Border.all(
                        color: const Color.fromRGBO(255, 255, 255, 0.05),
                      ),
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          color: isMe
                              ? const Color.fromRGBO(255, 255, 255, 0.7)
                              : const Color.fromRGBO(255, 255, 255, 0.5),
                          fontSize: 11,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isRead ? Icons.done_all : Icons.check,
                          size: 14,
                          color: message.isRead
                              ? const Color(0xFF4ECDC4)
                              : const Color.fromRGBO(255, 255, 255, 0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
