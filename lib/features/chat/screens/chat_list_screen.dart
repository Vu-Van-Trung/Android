import 'package:flutter/material.dart';
import '../../../widgets/gradient_background.dart';
import '../models/conversation_model.dart';
import '../../../services/chat_service.dart';
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

  @override
  void initState() {
    super.initState();
    _loadConversations();
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
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: _filterConversations,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm tin nhắn...',
                  hintStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.4)),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color.fromRGBO(255, 255, 255, 0.6),
                  ),
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 0.08),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Color.fromRGBO(255, 255, 255, 0.6),
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _filterConversations('');
                          },
                        )
                      : null,
                ),
              ),
            ),
            // Chat list
            Expanded(
              child: _buildChatList(),
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
