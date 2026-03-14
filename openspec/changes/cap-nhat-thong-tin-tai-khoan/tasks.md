## 1. Setup Data & Dependencies
- [x] 1.1 Chạy lệnh cài đặt thư viện `image_picker`.
- [x] 1.2 Cập nhật `User` model trong `lib/models/user.dart` thêm 6 trường mới.

## 2. Cập nhật Giao diện Tài khoản & Ảnh bìa
- [x] 2.1 Refactor `ProfileHeader` (`lib/features/account/widgets/profile_header.dart`) để dùng `Stack` hiển thị cả ảnh bìa phía sau và avatar đè lên trên.
- [x] 2.2 Thêm nút bấm/icon lên Ảnh bìa và Avatar để gọi hàm chọn ảnh từ thư viện (`ImagePicker().pickImage(source: ImageSource.gallery)`).
- [x] 2.3 Xử lý hiển thị `Image.file` nếu `User` đã có `avatarPath` / `coverPath` cục bộ. Thay thế fallback bằng ảnh default.

## 3. Cập nhật Form Chỉnh sửa Hồ sơ
- [x] 3.1 Mở rộng `EditProfileScreen` (`lib/features/account/screens/edit_profile_screen.dart`).
- [x] 3.2 Thêm input 'Họ và tên', 'Số điện thoại'.
- [x] 3.3 Thêm phần chọn 'Ngày sinh' dùng `showDatePicker`.
- [x] 3.4 Thêm Dropdown chọn 'Giới tính' (Nam/Nữ/Khác).
- [x] 3.5 Cập nhật hàm validation và Submit (save) vào AuthService.

## 4. Kiểm thử
- [ ] 4.1 `flutter analyze`.
- [ ] 4.2 Chạy thử ứng dụng, kiểm tra việc load UI có bị lệch layout hay không.
