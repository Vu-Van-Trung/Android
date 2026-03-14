## 1. Setup cấu trúc thư mục

- [x] 1.1 Tạo folder structure `lib/features/account/` với `screens/` và `widgets/`
- [x] 1.2 Tạo widget `profile_header.dart` - Avatar initials và thông tin user
- [x] 1.3 Tạo widget `menu_item.dart` - Item menu điều hướng có icon và chevron

## 2. Màn hình Account chính

- [x] 2.1 Tạo `account_screen.dart` với profile header, menu items (Chỉnh sửa hồ sơ, Đổi mật khẩu, Cài đặt, Đăng xuất)
- [x] 2.2 Cập nhật `home_screen.dart` - thay thế `_buildAccountTab()` bằng widget `AccountScreen`

## 3. Màn hình Chỉnh sửa hồ sơ

- [x] 3.1 Tạo `edit_profile_screen.dart` với form chỉnh sửa tên và email, validation, loading state

## 4. Màn hình Đổi mật khẩu

- [x] 4.1 Tạo `change_password_screen.dart` với form mật khẩu cũ, mật khẩu mới, xác nhận mật khẩu, validation

## 5. Màn hình Cài đặt

- [x] 5.1 Tạo `settings_screen.dart` với toggle switches cho thông báo, bảo mật, giao diện, và phiên bản app

## 6. Kiểm thử

- [x] 6.1 Chạy `flutter analyze` để kiểm tra lỗi code
- [x] 6.2 Chạy app và verify tất cả navigation hoạt động đúng
