## ADDED Requirements

### Requirement: Provide demo contact accounts
Hệ thống SHALL cung cấp dữ liệu demo cho ít nhất 5 tài khoản liên hệ để test và phát triển tính năng.

#### Scenario: Load demo data
- **WHEN** ứng dụng chạy ở chế độ development hoặc demo
- **THEN** hệ thống tự động load danh sách demo contacts vào màn hình danh bạ

#### Scenario: Demo data includes required fields
- **WHEN** load demo data
- **THEN** mỗi contact demo MUST có đầy đủ thông tin: id, tên, số điện thoại, avatar URL (hoặc placeholder), và trạng thái online/offline

### Requirement: Demo data variety
Demo contacts SHALL bao gồm các trường hợp đa dạng để test nhiều scenarios khác nhau.

#### Scenario: Variety in demo data
- **WHEN** xem danh sách demo contacts
- **THEN** danh sách bao gồm:
  - Liên hệ có avatar và không có avatar
  - Liên hệ online và offline
  - Tên có độ dài khác nhau (ngắn và dài)
  - Số điện thoại có format khác nhau

### Requirement: Easy toggle demo mode
Hệ thống SHALL cho phép developer dễ dàng bật/tắt chế độ sử dụng demo data thông qua config hoặc flag.

#### Scenario: Enable demo mode
- **WHEN** developer set flag `USE_DEMO_DATA = true`
- **THEN** hệ thống sử dụng demo contacts thay vì data từ API

#### Scenario: Disable demo mode
- **WHEN** developer set flag `USE_DEMO_DATA = false`
- **THEN** hệ thống load contacts từ API hoặc local storage thực tế
