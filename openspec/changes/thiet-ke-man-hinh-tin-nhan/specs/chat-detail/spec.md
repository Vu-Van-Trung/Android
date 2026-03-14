## ADDED Requirements

### Requirement: Khung chat chi tiết 1-1
Hệ thống SHALL cung cấp màn hình chi tiết để người dùng xem lịch sử chat và gửi tin nhắn mới với cá nhân.

#### Scenario: Hiển thị lịch sử chat
- **WHEN** người dùng truy cập màn hình Chat Detail
- **THEN** hệ thống hiển thị AppBar với Avatar, tên, trạng thái hoạt động (Online/Offline) của người đối diện và hiển thị danh sách các tin nhắn dưới dạng bong bóng (bong bóng của mình bên phải, của đối tác bên trái).

#### Scenario: Hiển thị thanh nhập liệu
- **WHEN** người dùng ở màn hình Chat Detail
- **THEN** hệ thống hiển thị một khung nhập văn bản ở cạnh dưới màn hình kèm một nút "Gửi".

#### Scenario: Nhập và gửi tin nhắn
- **WHEN** người dùng nhập văn bản vào khung và bấm nút "Gửi"
- **THEN** văn bản biến mất khỏi khung nhập, một bong bóng tin nhắn mới xuất hiện ở phía bên phải danh sách tin nhắn, và danh sách tự động cuộn xuống cuối cùng.

#### Scenario: Trạng thái nút gửi trống
- **WHEN** khung nhập liệu không có văn bản hoặc chỉ có khoảng trắng
- **THEN** nút "Gửi" không thể bấm (disabled) hoặc không thực hiện chức năng gửi.
