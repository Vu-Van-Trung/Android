# 💓 Pulse - The Heartbeat of Chat

**Pulse** là một ứng dụng nhắn tin thời gian thực hiện đại, được xây dựng bằng **Flutter**. Ứng dụng tập trung vào trải nghiệm người dùng mượt mà, giao diện cao cấp và khả năng giao tiếp tức thời.

---

## ✨ Tính Năng Chính

### 🔐 Xác Thực & Bảo Mật
- **Google Sign-In**: Đăng nhập nhanh chóng bằng tài khoản Google.
- **Email/Password**: Xác thực truyền thống qua Firebase Auth.
- **User Profile**: Quản lý thông tin cá nhân, cập nhật ảnh đại diện và tiểu sử.

### 💬 Trò Chuyện Thời Gian Thực
- **Direct Messaging**: Nhắn tin trực tiếp giữa các người dùng thông qua Socket.IO.
- **Real-time Status**: Thông báo trạng thái tin nhắn đã gửi/đã nhận.
- **Media Sharing**: Gửi hình ảnh và tệp tin qua tin nhắn.

### 👥 Quản Lý Bạn Bè
- **Friend Requests**: Gửi và nhận yêu cầu kết bạn.
- **Real-time Notifications**: Thông báo tức thì khi có yêu cầu kết bạn hoặc tin nhắn mới.
- **Contact List**: Quản lý danh sách liên lạc thông minh.

### 🎨 Giao Diện & Trải Nghiệm (UI/UX)
- **Glassmorphism Design**: Phong cách thiết kế kính mờ hiện đại.
- **Dark/Light Mode**: Hỗ trợ đầy đủ chế độ sáng/tối.
- **Micro-animations**: Các hiệu ứng chuyển động tinh tế giúp ứng dụng sinh động hơn.

---

## 🛠️ Công Nghệ Sử Dụng

- **Frontend**: Flutter (Dart)
- **Backend API**: FastAPI (Python) & MongoDB
- **Real-time**: Socket.IO
- **Auth & Cloud Services**: Firebase (Auth, Cloud Messaging, Firestore)
- **State Management**: ListenableBuilder / Provider pattern
- **Storage**: Cloudinary / Local Storage (tùy cấu hình backend)

---

## 📂 Cấu Trúc Thư Mục

```text
lib/
├── features/           # Các tính năng chính (Chat, Account, Contacts, Notification)
├── models/             # Định nghĩa cấu trúc dữ liệu (User, Message, Contact)
├── services/           # Xử lý Logic (API Client, Socket, Auth, Push Notification)
├── screens/            # Giao diện chính của ứng dụng
├── widgets/            # Các thành phần giao diện dùng chung (Button, Card, Input)
└── main.dart           # Điểm khởi đầu & Cấu hình Theme
```

---

## 🚀 Hướng Dẫn Cài Đặt

### 1. Yêu Cầu Hệ Thống
- Flutter SDK: `>=3.0.0`
- Dart SDK: `>=3.0.0`

### 2. Cấu Hình Firebase
1. Tạo một project trên [Firebase Console](https://console.firebase.google.com/).
2. Thêm ứng dụng Android/iOS.
3. Tải file `google-services.json` (Android) hoặc `GoogleService-Info.plist` (iOS) và đặt vào thư mục tương ứng.
4. Chạy lệnh: `flutterfire configure`.

### 3. Cấu Hình Backend
Đảm bảo bạn đã có backend chạy tại địa chỉ được cấu hình trong `lib/services/api_client.dart`:
```dart
static const String baseUrl = 'http://YOUR_API_IP:8000';
```

### 4. Chạy Ứng Dụng
```bash
# Lấy các gói phụ thuộc
flutter pub get

# Chạy project
flutter run
```

---

## 💡 Ghi Chú
- Hiện tại dự án đang được kết nối với Backend nội bộ qua IP tĩnh. Hãy đảm bảo máy ảo hoặc thiết bị thực của bạn có thể truy cập được địa chỉ IP này.
- Project sử dụng `Overlay Support` để hiển thị thông báo in-app.

---

## 📧 Liên Hệ
Nếu bạn có bất kỳ câu hỏi nào, vui lòng liên hệ qua email hoặc tạo một Issue trong repository này.

**Happy Chatting! 🚀**
