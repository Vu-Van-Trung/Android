import 'package:flutter/material.dart';
import '../../../widgets/gradient_background.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input_field.dart';
import '../../../services/chat_service.dart';
import '../../../services/api_client.dart';
import '../../../services/socket_service.dart';
import 'dart:async';

class ChatDetailScreen extends StatefulWidget {
  final Conversation conversation;

  const ChatDetailScreen({super.key, required this.conversation});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final ChatService _chatService = ChatService();
  late List<Message> _messages;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;
  bool _isLoadingMessages = true;
  StreamSubscription? _socketSubscription;

  // Lấy User ID từ session ApiClient đã login
  final String myUserId = ApiClient().userId ?? "anonymous"; 
  late String receiverId;

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.conversation.messages);
    receiverId = widget.conversation.partner.id;

    _loadMessages();

    // Lắng nghe tin nhắn từ SocketStream
    SocketService().currentChatId = widget.conversation.id;
    _socketSubscription = SocketService().onMessage.listen((data) {
      if (mounted) {
        // Chỉ append vào UI nếu tin nhắn đích thực thuộc phòng này
        final convId = data['conversation_id']?.toString();
        final senderId = (data['sender_id'] ?? data['sender'])?.toString();

        // Ignore socket echo sent by myself and ignore payloads without stable conversation_id.
        if (senderId == myUserId || convId == null || convId != widget.conversation.id) {
          return;
        }

        if (convId == widget.conversation.id) {
          setState(() {
            _messages.insert(
              0,
              Message(
                id: data['_id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
                text: data['text'] ?? data['content'] ?? '',
                timestamp: DateTime.now(),
                isSender: false, // Tin nhắn của người khác
                isRead: true,
              ),
            );
          });
          _scrollToBottom();
        }
      }
    });

    // Các tin nhắn mồi (mock) trước đó
    if (_messages.any((m) => !m.isSender && !m.isRead)) {
      _messages = _messages.map((m) {
        if (!m.isSender && !m.isRead) {
          return Message(
            id: m.id,
            text: m.text,
            timestamp: m.timestamp,
            isSender: m.isSender,
            isRead: true,
          );
        }
        return m;
      }).toList();
    }
  }

  @override
  void dispose() {
    SocketService().currentChatId = null;
    _socketSubscription?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _loadMessages() async {
    final msgs = await _chatService.getMessages(widget.conversation.id);
    if (mounted) {
      setState(() {
        // Reverse array as UI uses `reverse: true`
        _messages = msgs.reversed.toList();
        _isLoadingMessages = false;
      });
    }
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSending = true);

    // Xóa input
    _messageController.clear();

    // 1. Call REST Server
    final newMessage = await _chatService.sendMessage(widget.conversation.id, text);

    if (newMessage != null && mounted) {
      // 2. Gửi sự kiện lên Server Node.js thông qua Global Socket
      SocketService().sendMessage({
        'sender_id': myUserId,
        'sender': myUserId,
        'receiver_id': receiverId,
        'receiver': receiverId,
        'conversation_id': widget.conversation.id,
        'text': text,
        'content': text,
      });

      setState(() {
        // Insert at 0 because ListView is reversed
        _messages.insert(0, newMessage);
      });
      _scrollToBottom();
    }
    
    if (mounted) {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final partner = widget.conversation.partner;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 1,
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 18,
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
                if (partner.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4ECDC4),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF1A1A2E), // Match background
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    partner.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    partner.isOnline ? 'Đang hoạt động' : (partner.lastSeen ?? 'Ngoại tuyến'),
                    style: TextStyle(
                      fontSize: 12,
                      color: partner.isOnline
                          ? const Color(0xFF4ECDC4)
                          : const Color.fromRGBO(255, 255, 255, 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_outlined),
            onPressed: () {}, // Not implemented
          ),
          IconButton(
            icon: const Icon(Icons.videocam_outlined),
            onPressed: () {}, // Not implemented
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: GradientBackground(
        child: Column(
          children: [
            Expanded(
              child: _isLoadingMessages
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      reverse: true, // Show bottom to top
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        // For reverse ListView, index 0 is at bottom
                        final message = _messages[index];
                        return MessageBubble(
                          message: message,
                          partner: partner,
                        );
                      },
                    ),
            ),
            ChatInputField(
              controller: _messageController,
              onSend: _sendMessage,
              isSending: _isSending,
            ),
          ],
        ),
      ),
    );
  }
}
