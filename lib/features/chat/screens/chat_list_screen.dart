import 'dart:async';
import 'package:flutter/material.dart';
import '../../../widgets/gradient_background.dart';
import '../models/conversation_model.dart';
import '../../../services/chat_service.dart';
import '../../../services/socket_service.dart';
import '../models/message_model.dart';
import '../widgets/chat_list_item.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ChatService _chatService = ChatService();
  List<Conversation> _conversations = [];
  List<Conversation> _filteredConversations = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  StreamSubscription<Map<String, dynamic>>? _socketSub;

  @override
  void initState() {
    super.initState();
    _loadConversations();
    // Live preview: update conversation last message without full reload
    _socketSub = SocketService().onMessage.listen(_onNewSocketMessage);
  }

  void _onNewSocketMessage(Map<String, dynamic> data) {
    final convId = data['conversation_id']?.toString();
    if (convId == null || !mounted) return;

    final text = (data['content'] ?? data['text'] ?? '').toString();
    if (text.isEmpty) return;

    setState(() {
      final idx = _conversations.indexWhere((c) => c.id == convId);
      if (idx != -1) {
        final updated = Conversation(
          id: _conversations[idx].id,
          partner: _conversations[idx].partner,
          unreadCount: _conversations[idx].unreadCount + 1,
          messages: [
            Message(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              text: text,
              timestamp: DateTime.now(),
              isSender: false,
            ),
            ..._conversations[idx].messages,
          ],
        );
        _conversations
          ..removeAt(idx)
          ..insert(0, updated);
        _filterConversations(_searchQuery);
      } else {
        // Unknown conv — trigger full reload
        _loadConversations();
      }
    });
  }

  Future<void> _loadConversations() async {
    setState(() { _isLoading = true; });
    final convs = await _chatService.getConversations();
    if (mounted) {
      setState(() {
        _conversations = convs;
        _filteredConversations = List.from(_conversations);
        _isLoading = false;
        _filterConversations(_searchQuery); // apply active filter if any
      });
    }
  }

  @override
  void dispose() {
    _socketSub?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _filterConversations(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredConversations = List.from(_conversations);
      } else {
        _filteredConversations = _conversations.where((conv) {
          final nameMatch = conv.partner.name.toLowerCase().contains(_searchQuery);
          return nameMatch;
        }).toList();
      }
    });
  }

  void _navigateToDetail(Conversation conversation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(conversation: conversation),
      ),
    ).then((_) => _loadConversations());
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: _filterConversations,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm tin nhắn...',
                  hintStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.4)),
                  prefixIcon: const Icon(Icons.search, color: Color.fromRGBO(255, 255, 255, 0.6)),
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 0.08),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Color.fromRGBO(255, 255, 255, 0.6)),
                          onPressed: () {
                            _searchController.clear();
                            _filterConversations('');
                          },
                        )
                      : null,
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadConversations,
                color: const Color(0xFF667EEA),
                child: _buildChatList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList() {
    if (_conversations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Color.fromRGBO(255, 255, 255, 0.3),
            ),
            SizedBox(height: 16),
            Text(
              'Chưa có tin nhắn nào',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(255, 255, 255, 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (_filteredConversations.isEmpty) {
      return const Center(
        child: Text(
          'Không tìm thấy cuộc trò chuyện',
          style: TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(255, 255, 255, 0.5),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredConversations.length,
      itemBuilder: (context, index) {
        final conversation = _filteredConversations[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ChatListItem(
            conversation: conversation,
            onTap: () => _navigateToDetail(conversation),
          ),
        );
      },
    );
  }
}
