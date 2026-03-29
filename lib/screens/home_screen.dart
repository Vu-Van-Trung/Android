import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../features/contacts/screens/contacts_screen.dart';
import '../features/account/screens/account_screen.dart';
import '../features/chat/screens/chat_list_screen.dart';
import '../features/notification/screens/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  final AuthService authService;

  const HomeScreen({super.key, required this.authService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBackgroundColor = isDark ? const Color(0xFF1A1A2E) : const Color(0xFFFFFFFF);
    final unselectedColor = isDark ? const Color.fromRGBO(255, 255, 255, 0.6) : const Color.fromRGBO(0, 0, 0, 0.5);
    final appBarTitleColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(), style: TextStyle(color: appBarTitleColor)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const ChatListScreen(),
          const ContactsScreen(),
          const NotificationScreen(),
          AccountScreen(authService: widget.authService),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: navBackgroundColor,
        selectedItemColor: const Color(0xFF667EEA),
        unselectedItemColor: unselectedColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Tin nhắn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Danh bạ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Thông báo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Tin nhắn';
      case 1:
        return 'Danh bạ';
      case 2:
        return 'Thông báo';
      case 3:
        return 'Tài khoản';
      default:
        return 'DEMO Messenger';
    }
  }
}
