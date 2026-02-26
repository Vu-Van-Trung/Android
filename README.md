# 📱 Login App

Một ứng dụng đăng nhập/đăng ký hiện đại được xây dựng bằng **Flutter**, hỗ trợ xác thực hai lớp (TOTP - Two-Factor Authentication).

## ✨ Tính Năng Chính

- 🔐 **Đăng Nhập**: Giao diện đẹp mắt, dễ sử dụng
- 📝 **Đăng Ký**: Tạo tài khoản mới
- 🔑 **Quên Mật Khẩu**: Hỗ trợ khôi phục tài khoản
- 🛡️ **Xác Thực Hai Lớp (TOTP)**: Bảo mật mạnh mẽ với mã OTP
- 🎨 **Giao Diện Hiện Đại**: Sử dụng Glass Morphism Design + Gradient backgrounds

## 📂 Cấu Trúc Project

```
lib/
├── main.dart                    # Điểm khởi động ứng dụng
├── models/
│   └── user.dart              # Model người dùng
├── screens/
│   ├── login_screen.dart       # Màn hình đăng nhập
│   ├── register_screen.dart    # Màn hình đăng ký
│   ├── forgot_password_screen.dart  # Màn hình quên mật khẩu
│   ├── totp_setup_screen.dart  # Màn hình cài đặt TOTP
│   ├── totp_screen.dart        # Màn hình xác thực TOTP
│   └── success_screen.dart     # Màn hình thành công
├── services/
│   └── auth_service.dart       # Dịch vụ xử lý xác thực
└── widgets/
    ├── glass_card.dart         # Widget thẻ glass morphism
    └── gradient_background.dart # Widget nền gradient
```

## 🚀 Cách Sử Dụng

### 1. **Chuẩn Bị Môi Trường**

Chắc chắn bạn đã cài đặt Flutter:
```bash
flutter --version
```

Nếu chưa, cài đặt tại: https://flutter.dev/docs/get-started/install

### 2. **Clone hoặc Tải Project**

```bash
cd login_app
```

### 3. **Cài Đặt Dependencies**

```bash
flutter pub get
```

### 4. **Chạy Ứng Dụng**

**Trên Android Emulator/Device:**
```bash
flutter run
```

**Trên iOS Simulator:**
```bash
flutter run -d <device-name>
```

**Trên Web:**
```bash
flutter run -d chrome
```

## 🛠️ Công Nghệ Sử Dụng

- **Flutter**: Framework phát triển ứng dụng di động
- **Dart**: Ngôn ngữ lập trình
- **Provider** (nếu sử dụng): Quản lý trạng thái
- **TOTP**: Xác thực hai lớp

## 📚 Tài Liệu Tham Khảo

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Programming Language](https://dart.dev/guides)
- [Flutter Codelab](https://codelabs.developers.google.com/)

## 💡 Ghi Chú

- Ứng dụng này là một bản demo, chưa kết nối với backend thực
- Hãy cấu hình API endpoint trong `auth_service.dart` để kết nối với máy chủ của bạn

## 📧 Hỗ Trợ

Nếu bạn gặp vấn đề, hãy kiểm tra:
1. Flutter được cài đặt đúng
2. Dependencies được tải đầy đủ (`flutter pub get`)
3. Emulator/Device kết nối bình thường

---

**Happy Coding! 🎉**
