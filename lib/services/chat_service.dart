import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'api_client.dart';
import '../features/chat/models/conversation_model.dart';
import '../features/chat/models/message_model.dart';
import '../features/contacts/models/contact_model.dart';

class ChatService {
  final ApiClient _apiClient = ApiClient();

  /// Lấy danh sách cuộc trò chuyện
  Future<List<Conversation>> getConversations() async {
    try {
      final response = await _apiClient.get('/api/conversations');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> conversations = data['conversations'] ?? [];
        
        return conversations.map((item) {
          final String convId = item['_id']?.toString() ?? 'unknown_id';
          final String name = item['name'] ?? 'Trò chuyện';
          
          final contact = Contact(
            id: 'dummy_contact_id',
            name: name,
            phoneNumber: '',
            isOnline: false,
          );

          final List<Message> messages = [];
          if (item['last_message'] != null) {
            messages.add(
              Message(
                id: 'last_msg',
                text: item['last_message'] as String,
                timestamp: item['updated_at'] != null 
                    ? DateTime.tryParse(item['updated_at']) ?? DateTime.now() 
                    : DateTime.now(),
                isSender: false,
              )
            );
          }

          return Conversation(
            id: convId,
            partner: contact,
            messages: messages,
            unreadCount: 0,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting conversations: $e');
      return [];
    }
  }

  /// Lấy danh sách tin nhắn của 1 cuộc trò chuyện
  Future<List<Message>> getMessages(String conversationId, {int limit = 50, int skip = 0}) async {
    try {
      final response = await _apiClient.get(
        '/api/messages/$conversationId', 
        queryParams: {
          'limit': limit.toString(),
          'skip': skip.toString(),
        }
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> msgs = data['messages'] ?? [];
        final myUserId = _apiClient.userId;
        
        return msgs.map((item) {
          final senderId = item['sender_id']?.toString();
          return Message(
            id: item['_id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
            text: item['content'] ?? '',
            timestamp: item['created_at'] != null 
                ? DateTime.tryParse(item['created_at']) ?? DateTime.now() 
                : DateTime.now(),
            isSender: senderId != null && senderId == myUserId,
            isRead: item['status'] == 'read' || item['status'] == 'delivered',
          );
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting messages: $e');
      return [];
    }
  }

  /// Gửi một tin nhắn mới
  Future<Message?> sendMessage(String conversationId, String content) async {
    try {
      final response = await _apiClient.post('/api/messages', {
        'conversation_id': conversationId,
        'content': content,
      });
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          return Message(
            id: data['message_id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
            text: content,
            timestamp: DateTime.now(),
            isSender: true,
          );
        }
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
    return null;
  }
}
