## ADDED Requirements

### Requirement: Hiển thị thông tin profile
Hệ thống SHALL hiển thị màn hình profile tài khoản với avatar (initials), tên người dùng, email, và danh sách menu điều hướng đến các chức năng con.

#### Scenario: Hiển thị profile khi mở tab Tài khoản
- **WHEN** người dùng chọn tab "Tài khoản" trên bottom navigation
- **THEN** hệ thống hiển thị avatar initials, tên đăng nhập, email, và các menu items (Chỉnh sửa hồ sơ, Đổi mật khẩu, Cài đặt, Đăng xuất)

#### Scenario: Hiển thị avatar initials
- **WHEN** người dùng mở màn hình profile
- **THEN** hệ thống hiển thị avatar hình tròn với chữ cái đầu tiên của tên đăng nhập, nền gradient

### Requirement: Điều hướng từ profile
Hệ thống SHALL cho phép người dùng điều hướng đến các màn hình con từ menu items trên profile.

#### Scenario: Mở màn hình chỉnh sửa profile
- **WHEN** người dùng nhấn "Chỉnh sửa hồ sơ"
- **THEN** hệ thống điều hướng đến màn hình EditProfileScreen

#### Scenario: Mở màn hình đổi mật khẩu
- **WHEN** người dùng nhấn "Đổi mật khẩu"
- **THEN** hệ thống điều hướng đến màn hình ChangePasswordScreen

#### Scenario: Mở màn hình cài đặt
- **WHEN** người dùng nhấn "Cài đặt"
- **THEN** hệ thống điều hướng đến màn hình SettingsScreen

#### Scenario: Đăng xuất từ profile
- **WHEN** người dùng nhấn "Đăng xuất" và xác nhận
- **THEN** hệ thống đăng xuất và điều hướng về LoginScreen
