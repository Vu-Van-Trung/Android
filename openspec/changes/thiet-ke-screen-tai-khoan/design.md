## Context

Ứng dụng messenger doanh nghiệp Flutter hiện có tab "Tài khoản" là placeholder đơn giản chỉ hiển thị username, email và nút đăng xuất. Cần xây dựng màn hình tài khoản đầy đủ theo pattern feature-first đã thiết lập trong `features/contacts/`.

Codebase hiện có:
- `home_screen.dart`: Tab Tài khoản sử dụng `_buildAccountTab()` inline
- `GlassCard` và `GradientBackground` widgets cho UI glassmorphic dark theme
- `AuthService` với demo users, `User` model (username, email, password, totpSecret)
- Color scheme: primary `#667EEA`, background `#0F0F23`/`#1A1A2E`

## Goals / Non-Goals

**Goals:**
- Tạo màn hình profile tài khoản với avatar, thông tin cá nhân, và menu options
- Tạo màn hình chỉnh sửa profile (tên, email)
- Tạo màn hình đổi mật khẩu
- Tạo màn hình cài đặt (thông báo, bảo mật, giao diện)
- Sử dụng glassmorphic dark theme nhất quán với app
- Tuân thủ feature-first folder structure

**Non-Goals:**
- Kết nối API thật (chỉ demo/mock data)
- Upload avatar thật (sử dụng icon/initials avatar)
- Dark/Light mode toggle thực sự (chỉ UI placeholder)
- Quản lý phiên bản ứng dụng thật

## Decisions

### 1. Feature-first folder structure
**Quyết định**: Tạo `lib/features/account/` giống pattern `contacts/`
**Lý do**: Nhất quán với codebase, dễ mở rộng và bảo trì. Cấu trúc:
```
lib/features/account/
  screens/
    account_screen.dart       # Màn hình chính profile
    edit_profile_screen.dart  # Chỉnh sửa thông tin
    change_password_screen.dart # Đổi mật khẩu
    settings_screen.dart      # Cài đặt ứng dụng
  widgets/
    profile_header.dart       # Avatar + thông tin header
    menu_item.dart            # Item trong danh sách menu
```

### 2. Tái sử dụng widgets có sẵn
**Quyết định**: Tái sử dụng `GradientBackground`, `GlassCard` cho tất cả screens account
**Lý do**: Đảm bảo UI nhất quán, không duplicate code

### 3. Initials Avatar
**Quyết định**: Sử dụng avatar hiển thị chữ cái đầu tên thay vì ảnh
**Lý do**: Không cần image picker package, đơn giản cho demo, vẫn đẹp
**Thay thế**: Có thể mở rộng sau với `image_picker`

### 4. Navigation sử dụng Navigator.push
**Quyết định**: Sử dụng `Navigator.push` cho điều hướng từ account screen đến sub-screens
**Lý do**: Đơn giản, phù hợp với pattern hiện tại trong app

## Risks / Trade-offs

- **Demo data only** → Không cần migration, nhưng cần refactor khi kết nối API thật
- **No state management** → Sử dụng setState đơn giản. Cần refactor sang Provider/Bloc khi app lớn hơn
- **Hardcoded strings** → Chưa i18n, cần refactor sau khi thêm localization
