## 1. Setup Feature Structure

- [x] 1.1 Create `lib/features/contacts/` directory
- [x] 1.2 Create subdirectories: `models/`, `data/`, `screens/`, `widgets/`

## 2. Create Contact Model

- [x] 2.1 Create `lib/features/contacts/models/contact_model.dart`
- [x] 2.2 Define Contact class with properties: id, name, phoneNumber, avatarUrl (nullable), isOnline, lastSeen (nullable)
- [x] 2.3 Add toJson() and fromJson() methods for future API integration
- [x] 2.4 Add copyWith() method for immutability support

## 3. Create Demo Data

- [x] 3.1 Create `lib/features/contacts/data/demo_contacts.dart`
- [x] 3.2 Define at least 5 demo contacts với variety: có avatar/không có, online/offline, tên dài/ngắn
- [x] 3.3 Add USE_DEMO_DATA flag để dễ toggle demo mode

## 4. Build Contact List Item Widget

- [x] 4.1 Create `lib/features/contacts/widgets/contact_list_item.dart`
- [x] 4.2 Implement UI với CircleAvatar (hoặc default icon), tên, số điện thoại, online indicator
- [x] 4.3 Apply glass effect/styling consistent với existing GlassCard design
- [x] 4.4 Add onTap callback để support navigation

## 5. Implement Contacts Screen

- [x] 5.1 Create `lib/features/contacts/screens/contacts_screen.dart`
- [x] 5.2 Add GradientBackground wrapper
- [x] 5.3 Implement search TextField với icon ở AppBar hoặc top of screen
- [x] 5.4 Implement state management: _contacts list, _filteredContacts list, _searchQuery
- [x] 5.5 Implement search filter logic (case-insensitive, search by name hoặc phone)
- [x] 5.6 Build ListView.builder với ContactListItem widgets
- [x] 5.7 Handle empty states: "Chưa có liên hệ nào" và "Không tìm thấy liên hệ nào"
- [x] 5.8 Add placeholder navigation khi tap contact (ví dụ: show SnackBar "Chat với [name]")

## 6. Update HomeScreen Navigation

- [x] 6.1 Import ContactsScreen vào HomeScreen
- [x] 6.2 Implement IndexedStack hoặc conditional rendering dựa trên _currentIndex
- [x] 6.3 Update onTap handler của BottomNavigationBar để update _currentIndex
- [x] 6.4 Ensure tab "Danh ba" (index 1) hiển thị ContactsScreen
- [x] 6.5 Test navigation: tap book icon -> ContactsScreen appears, tap back -> return to previous tab

## 7. Testing and Polish

- [x] 7.1 Test search functionality với various queries
- [x] 7.2 Test empty states (no contacts, no search results)
- [x] 7.3 Test navigation flow: Home -> Contacts -> tap contact -> placeholder chat
- [x] 7.4 Verify UI consistency with existing theme (dark mode, colors, fonts)
- [x] 7.5 Test online/offline indicator display
- [x] 7.6 Run app và verify không có errors/warnings trong console
