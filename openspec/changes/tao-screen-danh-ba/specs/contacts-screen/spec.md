## ADDED Requirements

### Requirement: Display contacts list
Hệ thống SHALL hiển thị danh sách liên hệ/đồng nghiệp trong một màn hình riêng với giao diện trực quan và dễ sử dụng.

#### Scenario: Successfully display contacts list
- **WHEN** người dùng mở màn hình danh bạ
- **THEN** hệ thống hiển thị danh sách tất cả liên hệ với avatar, tên và thông tin cơ bản

#### Scenario: Display empty state
- **WHEN** người dùng chưa có liên hệ nào trong danh sách
- **THEN** hệ thống hiển thị thông báo "Chưa có liên hệ nào" với gợi ý thêm bạn bè

### Requirement: Search contacts
Hệ thống SHALL cho phép người dùng tìm kiếm liên hệ trong danh sách theo tên hoặc số điện thoại.

#### Scenario: Search by name
- **WHEN** người dùng nhập tên vào ô tìm kiếm
- **THEN** hệ thống hiển thị danh sách liên hệ có tên khớp với từ khóa (không phân biệt hoa thường)

#### Scenario: Search by phone number
- **WHEN** người dùng nhập số điện thoại vào ô tìm kiếm
- **THEN** hệ thống hiển thị liên hệ có số điện thoại khớp với từ khóa

#### Scenario: No search results
- **WHEN** tìm kiếm không có kết quả
- **THEN** hệ thống hiển thị thông báo "Không tìm thấy liên hệ nào"

### Requirement: Display contact details
Hệ thống SHALL hiển thị thông tin chi tiết của mỗi liên hệ bao gồm avatar, tên, số điện thoại và trạng thái online.

#### Scenario: Display contact item
- **WHEN** hiển thị một liên hệ trong danh sách
- **THEN** hệ thống hiển thị avatar (hoặc icon mặc định), tên đầy đủ, số điện thoại và indicator trạng thái online/offline

### Requirement: Navigate to chat
Hệ thống SHALL cho phép người dùng bắt đầu cuộc trò chuyện với một liên hệ bằng cách tap vào item trong danh sách.

#### Scenario: Start chat with contact
- **WHEN** người dùng tap vào một liên hệ trong danh bạ
- **THEN** hệ thống mở màn hình chat với liên hệ đó
