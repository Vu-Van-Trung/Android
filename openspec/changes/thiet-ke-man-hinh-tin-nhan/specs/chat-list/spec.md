## ADDED Requirements

### Requirement: Màn hình danh sách tin nhắn
Hệ thống SHALL hiển thị danh sách các cuộc trò chuyện gần đây nhất ở tab "Tin nhắn".

#### Scenario: Hiển thị danh sách chat
- **WHEN** người dùng mở ứng dụng và mặc định ở tab Tin nhắn
- **THEN** hệ thống hiển thị danh sách các cuộc trò chuyện, mỗi cuộc trò chuyện bao gồm: avatar, tên người gửi, nội dung tin nhắn cuối cùng, thời gian gửi, và badge số lượng tin nhắn chưa đọc (nếu có).

#### Scenario: Cuộn danh sách
- **WHEN** danh sách cuộc trò chuyện dài hơn chiều cao màn hình
- **THEN** người dùng có thể cuộn danh sách mượt mà

#### Scenario: Nhấn vào cuộc trò chuyện
- **WHEN** người dùng bấm vào một cuộc trò chuyện trong danh sách
- **THEN** hệ thống điều hướng đến màn hình Khung chat chi tiết (ChatDetailScreen) với người đó
