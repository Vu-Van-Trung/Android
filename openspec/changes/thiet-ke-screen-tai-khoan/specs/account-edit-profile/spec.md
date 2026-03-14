## ADDED Requirements

### Requirement: Chỉnh sửa thông tin cá nhân
Hệ thống SHALL cho phép người dùng chỉnh sửa tên hiển thị và email của mình.

#### Scenario: Hiển thị form chỉnh sửa với dữ liệu hiện tại
- **WHEN** người dùng mở màn hình chỉnh sửa hồ sơ
- **THEN** hệ thống hiển thị form với các trường tên đăng nhập và email được điền sẵn dữ liệu hiện tại

#### Scenario: Lưu thông tin thành công
- **WHEN** người dùng sửa thông tin và nhấn "Lưu thay đổi"
- **THEN** hệ thống hiển thị thông báo thành công và quay về màn hình profile

#### Scenario: Validation dữ liệu
- **WHEN** người dùng để trống trường bắt buộc hoặc nhập email không hợp lệ
- **THEN** hệ thống hiển thị thông báo lỗi tương ứng
