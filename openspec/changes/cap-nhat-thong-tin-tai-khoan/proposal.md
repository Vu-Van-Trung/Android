## Why

Màn hình "Chỉnh sửa hồ sơ" hiện tại chỉ hiển thị tên đăng nhập và email sơ sài. Người dùng cần cung cấp thêm các thông tin cá nhân cơ bản như số điện thoại, ngày sinh, họ tên, và giới tính để hoàn thiện hồ sơ. Ngoài ra, việc thiếu chức năng thay đổi ảnh đại diện (avatar) và ảnh bìa (cover photo) làm ứng dụng trở nên kém sinh động và thiếu tính cá nhân hóa.

## What Changes

- Cập nhật model `User` để hỗ trợ lưu trữ các trường thông tin mới: `fullName`, `phoneNumber`, `dateOfBirth`, `gender`, `avatarUrl`, và `coverUrl`.
- Nâng cấp màn hình "Chỉnh sửa hồ sơ" (`EditProfileScreen`) thêm các ô nhập liệu cho Họ tên, Số điện thoại, Ngày sinh (DatePicker), và Giới tính (Dropdown).
- Cập nhật màn hình "Tài khoản" (`AccountScreen`) và `ProfileHeader` để hiển thị ảnh bìa phía sau avatar, đồng thời tích hợp nút chức năng chọn ảnh từ thư viện máy (dùng `image_picker`) để thay đổi ảnh đại diện và ảnh bìa.

## Capabilities

### New Capabilities
- `account-cover-avatar`: Cho phép người dùng chọn ảnh từ thư viện thiết bị (`image_picker`) để làm ảnh đại diện và ảnh bìa ở phần đầu của màn hình Tài khoản hoặc khi chỉnh sửa hồ sơ.

### Modified Capabilities
- `account-edit-profile`: Mở rộng khả năng chỉnh sửa với các trường thông tin cá nhân mới: Số điện thoại, Ngày sinh, Giới tính, Họ tên.

## Impact

- **Code**: `user.dart`, `edit_profile_screen.dart`, `account_screen.dart`, `profile_header.dart` sẽ được sửa đổi đáng kể.
- **Dependencies**: Cần cài đặt thư viện `image_picker` để hỗ trợ chọn ảnh từ thư viện thiết bị điện thoại.
- **Dữ liệu**: Quá trình mô phỏng lưu dữ liệu sẽ được cập nhật để phản ánh các trường mới (do chưa có backend thực tế).
