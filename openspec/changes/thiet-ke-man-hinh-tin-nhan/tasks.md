## 1. Setup Models & Data

- [x] 1.1 Tạo `conversation_model.dart` (lưu trữ thông tin cuộc hội thoại cơ bản cho danh sách)
- [x] 1.2 Tạo `message_model.dart` (lưu trữ tin nhắn chi tiết, phân biệt gửi đi/nhận về)
- [x] 1.3 Tạo `demo_chats.dart` (mock data kết hợp với `demo_contacts`)

## 2. Xây dựng UI Danh sách Tin nhắn (Chat List)

- [x] 2.1 Tạo `chat_list_item.dart` (widget hiển thị 1 dòng trong danh sách chat)
- [x] 2.2 Tạo `chat_list_screen.dart` (hiển thị danh sách, xử lý tìm kiếm cơ bản tương tự contacts)
- [x] 2.3 Cập nhật `home_screen.dart` thay thế placeholder bằng `ChatListScreen`

## 3. Xây dựng UI Khung Chat (Chat Detail)

- [x] 3.1 Tạo `message_bubble.dart` (widget hiển thị bong bóng tin nhắn, hỗ trợ right/left alignment)
- [x] 3.2 Tạo `chat_input_field.dart` (thanh nhập văn bản có nút gửi)
- [x] 3.3 Tạo `chat_detail_screen.dart` (ghép message list và thanh nhập liệu, có AppBar thông tin người kia)

## 4. Tích hợp & Chuyển hướng

- [x] 4.1 Thêm logic điều hướng từ `ChatListScreen` sang `ChatDetailScreen`
- [x] 4.2 Thêm logic điều hướng từ `ContactsScreen` sang `ChatDetailScreen` (thay vì show Snackbar)
- [x] 4.3 Xử lý giả lập gửi tin nhắn (thêm vào cuối danh sách và cuộn xuống dưới cùng) trong `ChatDetailScreen`

## 5. Kiểm thử

- [x] 5.1 Chạy `flutter analyze`
- [ ] 5.2 Chạy màn hình UI và verify tương tác
