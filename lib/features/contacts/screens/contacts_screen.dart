import 'package:flutter/material.dart';
import '../../../widgets/gradient_background.dart';
import '../models/contact_model.dart';
import '../data/demo_contacts.dart';
import '../widgets/contact_list_item.dart';

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
    // Placeholder navigation - show snackbar for now
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mở chat với ${contact.name}'),
        backgroundColor: const Color(0xFF667EEA),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
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
