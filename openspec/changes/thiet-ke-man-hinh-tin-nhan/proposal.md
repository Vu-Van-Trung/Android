## Why

Hiện tại màn hình "Tin nhắn" (tab mặc định khi mở app) chỉ là một placeholder đơn giản với dòng chữ "Chức năng đang phát triển". Để ứng dụng messenger có thể hoạt động, tính năng cốt lõi là nhắn tin cần được thiết kế và triển khai, bao gồm danh sách các cuộc trò chuyện gần đây và khung chat chi tiết với từng người.

## What Changes

- Thay thế placeholder tab "Tin nhắn" bằng màn hình danh sách các cuộc trò chuyện (Chat List)
- Tạo màn hình chi tiết cuộc trò chuyện (Chat Detail) dùng để nhắn tin 1-1
- Tạo các model để lưu trữ dữ liệu cuộc trò chuyện và tin nhắn (Conversation, Message)
- Tạo dữ liệu demo (mock data) cho tin nhắn để hiển thị UI
- Kết nối hành động "Mở chat" từ màn hình Danh bạ (Contacts) sang màn hình Chat Detail

## Capabilities

### New Capabilities
- `chat-list`: Màn hình danh sách các đoạn chat gần đây, hiển thị avatar, tên người gửi, tin nhắn cuối cùng, thời gian và số lượng tin nhắn chưa đọc
- `chat-detail`: Khung chat chi tiết 1-1 hiển thị lịch sử tin nhắn dưới dạng bong bóng (bubbles) và thanh nhập tin nhắn mới ở dưới cùng

### Modified Capabilities
_(Không có)_

## Impact

- **Code**: `home_screen.dart` sẽ sử dụng `ChatListScreen` thay vì `_buildMessagesTab()`
- **Files mới**: Tạo module `lib/features/chat/` với các thư mục `screens/`, `widgets/`, `models/`, và `data/`
- **Naviation**: Bổ sung điều hướng từ `ContactsScreen` sang `ChatDetailScreen`
- **Dependencies**: Không yêu cầu package bổ sung, sử dụng Flutter widgets chuẩn
