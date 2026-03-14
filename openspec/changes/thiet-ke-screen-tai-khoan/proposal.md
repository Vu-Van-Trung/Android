## Why

Hiện tại tab "Tài khoản" trong ứng dụng chỉ là placeholder đơn giản hiển thị tên đăng nhập, email và nút đăng xuất. Cần thiết kế lại màn hình tài khoản với đầy đủ chức năng quản lý profile người dùng, cài đặt ứng dụng, và các tính năng cơ bản khác cho một ứng dụng nhắn tin doanh nghiệp.

## What Changes

- Thay thế tab Tài khoản placeholder bằng màn hình profile hoàn chỉnh với avatar, thông tin cá nhân
- Thêm màn hình chỉnh sửa thông tin cá nhân (tên hiển thị, email, số điện thoại)
- Thêm màn hình đổi mật khẩu
- Thêm phần cài đặt ứng dụng (thông báo, bảo mật, giao diện)
- Thêm mục thông tin ứng dụng (phiên bản, about)
- Giữ lại chức năng đăng xuất

## Capabilities

### New Capabilities
- `account-profile`: Màn hình hiển thị thông tin tài khoản người dùng với avatar, tên, email, số điện thoại, và các menu điều hướng đến các chức năng con
- `account-edit-profile`: Màn hình chỉnh sửa thông tin cá nhân (tên hiển thị, email)
- `account-change-password`: Màn hình đổi mật khẩu với xác thực mật khẩu cũ
- `account-settings`: Màn hình cài đặt ứng dụng (thông báo, bảo mật, giao diện tối/sáng)

### Modified Capabilities
_(Không có capabilities hiện tại cần sửa đổi ở cấp spec)_

## Impact

- **Code**: Thay thế `_buildAccountTab()` trong `home_screen.dart` bằng widget `AccountScreen` mới
- **Files mới**: Tạo feature module `lib/features/account/` với screens, widgets, và models
- **Dependencies**: Không cần thêm package mới, sử dụng Flutter Material widgets có sẵn
- **Navigation**: Thêm route navigation từ account screen đến các sub-screens (edit profile, change password, settings)
