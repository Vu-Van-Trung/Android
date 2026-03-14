## Context

Ứng dụng đang có tab "Tin nhắn" trống và màn hình "Danh bạ" có sẵn dữ liệu giả (`Contact` model và `demoContacts`). Cần xây dựng màn hình danh sách chat và màn hình chat chi tiết 1-1 để người dùng có thể gửi/nhận tin nhắn (hiện tại chỉ sử dụng dữ liệu giả trên giao diện chứ không cần socket thật). 

## Goals / Non-Goals

**Goals:**
- Xây dựng UI danh sách tin nhắn hoạt động mượt mà
- Xây dựng UI khung chat 1-1 với các bong bóng tin nhắn (message bubbles) phân biệt người gửi/người nhận
- Có thanh nhập tin nhắn với nút gửi
- Tích hợp với màn hình Danh bạ hiện tại để có thể mở khung chat với một người
- Giao diện nhất quán với thiết kế Glassmorphism nền tối (Dark mode)

**Non-Goals:**
- Kết nối real-time qua Socket.io (chỉ làm giao diện trước)
- Quản lý state nâng cao (Provider/BLoC) - sẽ dùng `StatefulWidget` cơ bản cho tính năng nhập/hiển thị tin nhắn
- Gửi hình ảnh, file đính kèm (giữ gọn cho tính năng chat văn bản trước)
- Chat nhóm (chỉ tập trung vào chat 1-1)

## Decisions

### 1. Cấu trúc thư mục (Feature-First)
**Quyết định**: Tạo thư mục `lib/features/chat/`
**Lý do**: Tương đồng với tính năng Contacts và Account.
```
lib/features/chat/
  models/
    message_model.dart       # Model tin nhắn chi tiết
    conversation_model.dart  # Model cuộc trò chuyện (danh sách)
  data/
    demo_chats.dart          # Dữ liệu giả định dựa trên demo_contacts
  screens/
    chat_list_screen.dart    # Tab tin nhắn ở màn hình chính
    chat_detail_screen.dart  # Khung chat 1-1
  widgets/
    chat_list_item.dart      # Item trên danh sách
    message_bubble.dart      # Bong bóng tin nhắn
    chat_input_field.dart    # Khung nhập văn bản ở dưới
```

### 2. Thiết kế giao diện (UI/UX)
**Quyết định**: 
- Sử dụng `GradientBackground` và thiết kế thẻ `GlassCard` hoặc list trong suốt để nhất quán.
- Message bubbles: màu `Primary (#667EEA)` cho tin nhắn của người dùng hiện tại (nằm bên phải), màu nền Glass mờ cho tin người khác (nằm bên trái).
- Appbar của màn hình chat chi tiết sẽ hiển thị avatar, tên người dùng, và trạng thái online (từ `Contact` model).

### 3. Tái sử dụng model Contact
**Quyết định**: Tái sử dụng `Contact` từ `lib/features/contacts/models/contact_model.dart` làm thông tin định danh cho người đang chat (Partner).
**Lý do**: Giảm việc tạo model thừa, đảm bảo tính nhất quán của định danh người dùng trong app.

## Risks / Trade-offs

- **Chưa có State Management toàn cục**: Khi user gửi tin nhắn ở ChatDetailScreen, nó chỉ cập nhật nội bộ widget đó, chưa cập nhật ra "Tin nhắn cuối cùng" ở ChatListScreen (do dùng data tĩnh). Sẽ chấp nhận hạn chế này trong phase giao diện.
- **Bàn phím che khuất tin nhắn**: Cần cẩn thận sử dụng ListView có `reverse: true` và bọc `SafeArea`, `Scaffold` tốt để Keyboard không đè lên thanh nhập liệu.
