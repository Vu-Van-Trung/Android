## ADDED Requirements

### Requirement: Đổi mật khẩu
Hệ thống SHALL cho phép người dùng đổi mật khẩu với xác thực mật khẩu hiện tại.

#### Scenario: Đổi mật khẩu thành công
- **WHEN** người dùng nhập mật khẩu hiện tại đúng, mật khẩu mới, và xác nhận mật khẩu mới khớp nhau
- **THEN** hệ thống hiển thị thông báo thành công và quay về màn hình profile

#### Scenario: Mật khẩu hiện tại không đúng
- **WHEN** người dùng nhập mật khẩu hiện tại sai
- **THEN** hệ thống hiển thị thông báo "Mật khẩu hiện tại không đúng"

#### Scenario: Mật khẩu mới không khớp
- **WHEN** người dùng nhập mật khẩu mới và xác nhận mật khẩu không giống nhau
- **THEN** hệ thống hiển thị thông báo "Mật khẩu xác nhận không khớp"

#### Scenario: Mật khẩu mới quá ngắn
- **WHEN** người dùng nhập mật khẩu mới dưới 6 ký tự
- **THEN** hệ thống hiển thị thông báo "Mật khẩu phải có ít nhất 6 ký tự"
