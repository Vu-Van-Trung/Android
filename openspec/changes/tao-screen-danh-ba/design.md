## Context

Ứng dụng hiện tại đã có một màn hình chính (`HomeScreen`) với bottom navigation bar bao gồm 3 tabs: "Tin nhan", "Danh ba", và "Tai khoan". Tab "Danh ba" (Contacts) đã được định nghĩa với icon `Icons.menu_book_outlined` nhưng chưa có functionality thực tế - khi người dùng nhấn vào tab này, vẫn hiển thị màn hình chính.

Dự án sử dụng:
- Flutter với Material Design  
- Đã có cấu trúc thư mục: `lib/screens/`, `lib/models/`, `lib/widgets/`, `lib/services/`
- Đã có theme system với dark mode, gradient background, và glass card design
- State management: StatefulWidget (có thể mở rộng sang Provider/Bloc sau này)
- Navigation: Flutter Navigator

## Goals / Non-Goals

**Goals:**
- Tạo màn hình danh bạ hiển thị danh sách liên hệ với UI nhất quán với design hiện tại
- Implement navigation từ tab "Danh ba" trong bottom navigation bar sang ContactsScreen
- Tạo Contact model để định nghĩa cấu trúc dữ liệu
- Cung cấp demo data với ít nhất 5 contacts để phát triển và test
- Hỗ trợ tìm kiếm contacts theo tên hoặc số điện thoại
- Hiển thị trạng thái online/offline của contacts
- Cho phép tap vào contact để navigate sang chat screen (placeholder)

**Non-Goals:**
- API integration để fetch contacts từ server (sử dụng demo data)
- QR code scanning để thêm bạn
- Sync contacts từ phonebook device
- Implement chat screen đầy đủ (chỉ placeholder navigation)
- Group management trong contacts

## Decisions

### Decision 1: Feature-based folder structure for contacts
**Rationale:** Sử dụng feature-first structure thay vì layer-first để dễ scale và maintain.

**Structure:**
```
lib/
  features/
    contacts/
      models/
        contact_model.dart
      data/
        demo_contacts.dart
      screens/
        contacts_screen.dart
      widgets/
        contact_list_item.dart
```

**Alternatives considered:**
- Giữ tất cả models ở `lib/models/` - không scale tốt khi app lớn
- Flat structure trong `lib/screens/` - khó quản lý khi có nhiều features

**Chosen approach:** Feature-based vì phù hợp với clean architecture pattern đã được định nghĩa trong project context.

### Decision 2: State management cho contacts screen
**Rationale:** Sử dụng StatefulWidget với local state cho demo data. 

**Why:**
- Demo data không cần phức tạp hóa với Provider/Bloc
- Dễ migrate lên state management pattern sau khi có real API
- Consistent với implementation hiện tại của HomeScreen

**Future migration path:** Khi integrate real API, sẽ chuyển sang:
- ContactsBloc/ContactsProvider để manage state
- Repository pattern để abstract data source

### Decision 3: Sử dụng ListView.builder cho danh sách contacts
**Rationale:** Performance optimization cho danh sách lớn.

**Why:**
- Lazy loading - chỉ build widgets khi cần thiết
- Memory efficient
- Standard practice trong Flutter

### Decision 4: Search implementation với local filtering
**Rationale:** Implement search ở client-side với demo data.

**Implementation:**
- TextField with onChanged callback
- Filter list dựa trên search query (case-insensitive)
- Debouncing không cần thiết cho demo data nhỏ

**Future enhancement:** Khi có API, implement server-side search với debouncing.

### Decision 5: Navigation pattern
**Rationale:** Sử dụng _currentIndex state trong HomeScreen để switch giữa các screens/tabs.

**Implementation:**
- Maintain các widget screens khác nhau
- Dùng IndexedStack hoặc conditional rendering dựa trên _currentIndex
- Book icon tap -> set _currentIndex = 1 -> hiển thị ContactsScreen

**Alternatives considered:**
- Navigator độc lập cho mỗi tab - phức tạp hơn, overkill cho v1
- PageView - không cần swipe gesture cho tab navigation

**Chosen approach:** Simple state-based switching vì:
- Đơn giản, dễ implement
- Phù hợp với bottom navigation UX pattern
- Dễ maintain state của từng tab

### Decision 6: Contact model structure
```dart
class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String? avatarUrl;
  final bool isOnline;
  final String? lastSeen;
}
```

**Rationale:**
- `id`: Unique identifier cho mỗi contact - cần cho database/API sau này
- `avatarUrl`: Optional vì một số contacts có thể không có avatar
- `isOnline`: Boolean flag để hiển thị indicator
- `lastSeen`: Optional timestamp cho offline users

### Decision 7: Reuse existing UI components
**Rationale:** Tái sử dụng `GlassCard`, `GradientBackground` để maintain design consistency.

**Usage:**
- ContactsScreen sử dụng GradientBackground làm wrapper
- Contact list items có thể dùng glass effect tương tự

## Risks / Trade-offs

**[Risk]** Không có proper error handling cho search/filter
**→ Mitigation:** Implement try-catch trong filter logic, hiển thị error state nếu có exception

**[Risk]** Demo data hardcoded - khó switch sang real API
**→ Mitigation:**  
- Tạo separate file `demo_contacts.dart` trong `data/` folder
- Sử dụng flag `USE_DEMO_DATA` để dễ dàng toggle
- Structure Contact model để compatible với API response

**[Trade-off]** Navigation pattern đơn giản có thể không scale cho deep navigation
**→ Accepted:** Cho V1 với contacts screen, pattern này đủ. Khi cần nested navigation (ví dụ: contact details -> edit contact), sẽ refactor sang nested Navigator.

**[Trade-off]** Search ở client-side sẽ không efficient với danh sách lớn (>1000 contacts)
**→ Accepted:** Demo data chỉ ~5-10 contacts. Khi có real API, sẽ implement server-side search với pagination.

**[Risk]** Không có loading states
**→ Mitigation:** Vì là demo data (synchronous), không cần loading. Khi integrate API (asynchronous), sẽ thêm loading indicators.

## Migration Plan

**Phase 1 - V1 Implementation (this change):**
1. Create Contact model
2. Create demo contacts data file
3. Implement ContactsScreen with search UI
4. Update HomeScreen to handle tab navigation
5. Add placeholder chat navigation

**Phase 2 - Future API Integration:**
1. Create ContactsRepository interface
2. Implement API data source
3. Add loading/error states
4. Implement server-side search
5. Add pull-to-refresh
6. Cache contacts locally (SQLite/Hive)

**Rollback strategy:**
- Git revert/cherry-pick specific commits
- Demo data switch flag cho phép disable feature nếu cần

## Open Questions

None - all design decisions are clear for V1 implementation with demo data.
