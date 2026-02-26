## ADDED Requirements

### Requirement: Book icon on main screen
Hệ thống SHALL hiển thị icon hình cuốn sách (book icon) trên màn hình chính để người dùng có thể truy cập vào màn hình danh bạ.

#### Scenario: Display book icon
- **WHEN** người dùng vào màn hình chính
- **THEN** hệ thống hiển thị book icon ở vị trí dễ nhìn và dễ truy cập (ví dụ: top app bar, floating action button, hoặc bottom navigation bar)

### Requirement: Navigate to contacts screen
Hệ thống SHALL điều hướng người dùng từ màn hình chính sang màn hình danh bạ khi nhấn vào book icon.

#### Scenario: Successful navigation
- **WHEN** người dùng tap vào book icon trên màn hình chính
- **THEN** hệ thống chuyển sang màn hình danh bạ với animation mượt mà

#### Scenario: Back navigation
- **WHEN** người dùng nhấn nút back trên màn hình danh bạ
- **THEN** hệ thống quay lại màn hình chính

### Requirement: Icon visibility
Book icon SHALL luôn hiển thị trên màn hình chính khi người dùng đã đăng nhập.

#### Scenario: Icon visible for logged-in users
- **WHEN** người dùng đã đăng nhập và ở màn hình chính
- **THEN** book icon hiển thị và có thể tương tác được
