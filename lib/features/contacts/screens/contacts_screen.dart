import 'package:flutter/material.dart';
import '../../../widgets/gradient_background.dart';
import '../models/contact_model.dart';
import '../data/demo_contacts.dart';
import '../widgets/contact_list_item.dart';
import '../../chat/models/conversation_model.dart';
import '../../chat/data/demo_chats.dart';
import '../../chat/screens/chat_detail_screen.dart';
import '../../../services/contact_service.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ContactService _contactService = ContactService();
  bool _isAddingFriend = false;

  @override
  void initState() {
    super.initState();
    // Load demo contacts if useDemoData is true
    if (useDemoData) {
      _contacts = List.from(demoContacts);
      _filteredContacts = List.from(demoContacts);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterContacts(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredContacts = List.from(_contacts);
      } else {
        _filteredContacts = _contacts.where((contact) {
          final nameMatch = contact.name.toLowerCase().contains(_searchQuery);
          final phoneMatch = contact.phoneNumber.contains(_searchQuery);
          return nameMatch || phoneMatch;
        }).toList();
      }
    });
  }

  void _handleContactTap(Contact contact) {
    // Check if conversation exists in demo data
    Conversation? existingConv;
    try {
      existingConv = demoConversations.firstWhere((c) => c.partner.id == contact.id);
    } catch (_) {}

    final conversation = existingConv ?? Conversation(
      id: 'new_${contact.id}',
      partner: contact,
      messages: [],
      unreadCount: 0,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(conversation: conversation),
      ),
    );
  }

  void _showAddFriendDialog() {
    final phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: Text('Thêm bạn bè', style: Theme.of(context).textTheme.titleLarge),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Nhập số điện thoại để kết bạn'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Số điện thoại',
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: _isAddingFriend ? null : () async {
                    final phone = phoneController.text.trim();
                    if (phone.isEmpty) {
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng nhập số điện thoại')),
                      );
                      return;
                    }

                    final validPhone = RegExp(r'^[0-9+\s()-]{8,15}$').hasMatch(phone);
                    if (!validPhone) {
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(content: Text('Số điện thoại không hợp lệ')),
                      );
                      return;
                    }
                    
                    setDialogState(() => _isAddingFriend = true);
                    final result = await _contactService.addFriend(phone);
                    setDialogState(() => _isAddingFriend = false);

                    if (result['success'] == true) {
                      final friendId = (result['friend_id'] ?? 'friend_$phone').toString();
                      final existed = _contacts.any((c) => c.id == friendId || c.phoneNumber == phone);

                      if (!existed) {
                        setState(() {
                          _contacts.insert(
                            0,
                            Contact(
                              id: friendId,
                              name: 'Bạn mới $phone',
                              phoneNumber: phone,
                              isOnline: false,
                              lastSeen: 'Vừa thêm',
                            ),
                          );
                          final activeQuery = _searchController.text.toLowerCase();
                          _searchQuery = activeQuery;
                          if (activeQuery.isEmpty) {
                            _filteredContacts = List.from(_contacts);
                          } else {
                            _filteredContacts = _contacts.where((contact) {
                              final nameMatch = contact.name.toLowerCase().contains(activeQuery);
                              final phoneMatch = contact.phoneNumber.contains(activeQuery);
                              return nameMatch || phoneMatch;
                            }).toList();
                          }
                        });
                      }
                    }

                    if (mounted && context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        SnackBar(
                          content: Text(result['message']),
                          backgroundColor: result['success'] ? Colors.green : Colors.red,
                        ),
                      );
                    }
                  },
                  child: _isAddingFriend
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Kết bạn'),
                ),
              ],
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFriendDialog,
        backgroundColor: const Color(0xFF667EEA),
        foregroundColor: Colors.white,
        child: const Icon(Icons.person_add),
      ),
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterContacts,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm theo tên hoặc số điện thoại...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color.fromRGBO(255, 255, 255, 0.6),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Color.fromRGBO(255, 255, 255, 0.6),
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _filterContacts('');
                            },
                          )
                        : null,
                  ),
                ),
              ),
              // Contact list
              Expanded(
                child: _buildContactList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactList() {
    // Empty state - no contacts at all
    if (_contacts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.contacts_outlined,
              size: 64,
              color: Color.fromRGBO(255, 255, 255, 0.3),
            ),
            SizedBox(height: 16),
            Text(
              'Chưa có liên hệ nào',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(255, 255, 255, 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Hãy thêm bạn bè để bắt đầu trò chuyện',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(255, 255, 255, 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Empty state - no search results
    if (_filteredContacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: Color.fromRGBO(255, 255, 255, 0.3),
            ),
            const SizedBox(height: 16),
            const Text(
              'Không tìm thấy liên hệ nào',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(255, 255, 255, 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Không có kết quả cho "$_searchQuery"',
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(255, 255, 255, 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Display contacts
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredContacts.length,
      itemBuilder: (context, index) {
        final contact = _filteredContacts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ContactListItem(
            contact: contact,
            onTap: () => _handleContactTap(contact),
          ),
        );
      },
    );
  }
}
