## ADDED Requirements

### Requirement: Cập nhật thông tin cá nhân bổ sung
Hệ thống SHALL cho phép người dùng xem và chỉnh sửa các trường thông tin: Họ tên, Số điện thoại, Ngày sinh, Giới tính.

#### Scenario: Chỉnh sửa thông tin
- **WHEN** người dùng vào màn hình "Chỉnh sửa hồ sơ"
- **THEN** hệ thống sẽ hiển thị các ô input cho: Họ Tên, Số điện thoại (chỉ nhập số), Ngày sinh (mở popup chọn ngày), Giới tính (chọn từ list Nam/Nữ/Khác).

#### Scenario: Cập nhật ảnh đại diện và ảnh bìa
- **WHEN** người dùng nhấn vào biểu tượng Đổi ảnh địa diện/Ảnh bìa ở màn hình Tài khoản (hoặc cấu hình ProfileHeader)
- **THEN** hệ thống mở thư viện ảnh của thiết bị để lựa chọn. Sau khi chọn xong, hình ảnh mới SHALL được hiển thị trên giao diện và lưu trữ đường dẫn.
