## Context
Ứng dụng cần bổ sung các trường thông tin cho tài khoản người dùng: Số điện thoại, Ngày sinh, Họ tên, Giới tính, Ảnh đại diện, và Ảnh bìa. 
Hiện tại `User` model chỉ chứa `{username, email, password, totpSecret}`. ProfileHeader cũng chỉ có màu gradient và ký tự đầu tiên của tên.

## Goals / Non-Goals
**Goals:**
- Mở rộng model User hiện tại.
- Cập nhật màn hình `EditProfileScreen` để nhập 4 trường mới, sử dụng DateTimePicker cho ngày sinh và Dropdown cho giới tính.
- Cập nhật màn hình `AccountScreen` & `ProfileHeader` để hiển thị ảnh bìa thật mượt mà, kết hợp với avatar.
- Tích hợp package `image_picker` để người dùng chọn ảnh từ Gallery của điện thoại.

**Non-Goals:**
- Chưa upload ảnh lên server (do ứng dụng đang dùng local data). Tạm thời lưu đường dẫn file ảnh cục bộ (local path) vào model bằng dạng chuỗi.
- Không tích hợp chụp ảnh trực tiếp bằng Camera (chỉ chọn ảnh từ Gallery cho nhanh và an toàn trên cả iOS/Android emulator).

## Decisions
### 1. Cập nhật Model
**Quyết định**: Thêm các thuộc tính mới vào `User` model (`lib/models/user.dart`). 
```dart
String? fullName;
String? phoneNumber;
DateTime? dateOfBirth;
String? gender; // 'Nam', 'Nữ', 'Khác'
String? avatarPath; 
String? coverPath;
```

### 2. Sử dụng image_picker 
**Quyết định**: Cài đặt `flutter pub add image_picker`. Khi chọn ảnh xong, dùng package `dart:io` `File` để hiển thị trên UI (`Image.file(File(path))`). Nếu chưa chọn ảnh thì fallback về Gradient Background (cho avatar) và color xám (cho cover).

## Risks / Trade-offs
- Permissions: Trên Android/iOS cần thêm permission đọc/ghi file. Vì chỉ dùng `image_picker` cho gallery, ta cần đảm bảo app có thể đọc file local.
- UI Cover Photo: `ProfileHeader` hiện đang là Column, sẽ được chuyển sang dạng `Stack` để cover photo nằm dưới cùng, sau đó là Avatar đè lên. Việc này cần điều chỉnh spacing cẩn thận để không vỡ layout tab Tài khoản.
