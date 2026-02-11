## Why

Người dùng cần một màn hình danh bạ để quản lý và xem danh sách liên hệ trong ứng dụng nhắn tin. Hiện tại chưa có màn hình danh bạ và không có cách nào để điều hướng từ màn hình chính sang xem danh sách liên hệ. Tính năng này cần thiết để người dùng có thể truy cập danh bạ và bắt đầu cuộc trò chuyện với các đồng nghiệp.

## What Changes

- Tạo màn hình danh bạ mới (ContactsScreen) hiển thị danh sách liên hệ
- Thêm dữ liệu demo cho các tài khoản liên hệ để test
- Thêm icon cuốn sách (book icon) vào màn hình chính
- Implement navigation từ màn hình chính sang màn hình danh bạ khi nhấn icon cuốn sách

## Capabilities

### New Capabilities
- `contacts-screen`: Màn hình hiển thị danh sách liên hệ với UI Material Design/Cupertino, hỗ trợ search và sort
- `contacts-navigation`: Điều hướng từ màn hình chính sang màn hình danh bạ thông qua book icon
- `demo-contacts-data`: Dữ liệu demo cho danh sách liên hệ để test và phát triển

### Modified Capabilities
- `main-screen-ui`: Thêm book icon vào main screen để trigger navigation sang contacts screen

## Impact

- **Files mới**: 
  - `lib/features/contacts/screens/contacts_screen.dart` - màn hình danh bạ
  - `lib/features/contacts/models/contact_model.dart` - model cho contact
  - `lib/features/contacts/data/demo_contacts.dart` - dữ liệu demo
  
- **Files chỉnh sửa**:
  - Main screen file (cần xác định tên file cụ thể) - thêm book icon và navigation logic
  - Navigation/routing file - thêm route cho contacts screen

- **Dependencies**: Không cần thêm package mới, sử dụng Flutter built-in widgets và navigation

- **UI/UX**: Thêm button/icon mới trên main screen, người dùng sẽ thấy thêm một điểm tương tác mới
