import 'dart:convert';
import 'api_client.dart';
import '../models/user.dart';

/// Authentication Service - handles login, registration, password reset
class AuthService {
  // Demo users
  static final List<User> _demoUsers = [
    const User(
      username: 'demo',
      email: 'demo@example.com',
      password: 'password123',
      totpSecret: 'JBSWY3DPEHPK3PXP',
    ),
    const User(
      username: 'admin',
      email: 'admin@example.com',
      password: 'admin123',
      totpSecret: 'HXDMVJECJJWSRB3H',
    ),
    const User(
      username: 'user',
      email: 'user@example.com',
      password: 'user123',
      totpSecret: 'KZXW6YTBON2XEZJO',
    ),
  ];

  // Demo TOTP code (in production, would use real TOTP algorithm)
  static const String demoTotpCode = '123456';

  User? _currentUser;

  User? get currentUser => _currentUser;

  /// Login with username/email and password
  Future<LoginResult> login(String usernameOrEmail, String password) async {
    try {
      final response = await ApiClient().post('/api/login', {
        'phone': usernameOrEmail,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        final userId = data['user_id']?.toString() ?? 'unknown_id';
        if (token != null) {
          ApiClient().setTokenAndUserId(token, userId);
          
          // Generate dummy user as API does not return profile
          _currentUser = User(
            username: usernameOrEmail,
            email: '$usernameOrEmail@domain.com',
            password: password,
            totpSecret: 'DUMMY',
          );

          return LoginResult(
            success: true,
            message: 'Đăng nhập thành công',
            requiresTOTP: false, 
          );
        }
      }
      
      return LoginResult(
        success: false,
        message: 'Đăng nhập thất bại: ${response.statusCode}',
      );
    } catch (e) {
      return LoginResult(
        success: false,
        message: 'Không thể kết nối Server: $e',
      );
    }
  }

  /// Verify TOTP code
  Future<LoginResult> verifyTOTP(String code) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Accept demo code or any 6-digit code starting with "1"
    if (code == demoTotpCode || code.startsWith('1')) {
      return LoginResult(success: true, message: 'Xác thực thành công');
    }

    return LoginResult(success: false, message: 'Mã xác thực không đúng');
  }

  /// Register new user
  Future<RegisterResult> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Dùng tham số email như phone theo design API của user.
      final response = await ApiClient().post('/api/register', {
        'phone': email, 
        'password': password,
        'full_name': username,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResult(
          success: true,
          message: 'Đăng ký thành công',
          totpSecret: _generateSecretKey(),
        );
      }
      
      String errorMsg = 'Lỗi đăng ký: ${response.statusCode}';
      try {
        final data = jsonDecode(response.body);
        if (data['detail'] != null) {
          errorMsg = data['detail'];
        }
      } catch (_) {}

      return RegisterResult(
        success: false,
        message: errorMsg,
      );
    } catch (e) {
      return RegisterResult(
        success: false,
        message: 'Lỗi kết nối: $e',
      );
    }
  }

  /// Request password reset
  Future<ResetResult> requestPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final user = _demoUsers.firstWhere(
      (u) => u.email == email,
      orElse: () =>
          const User(username: '', email: '', password: '', totpSecret: ''),
    );

    if (user.email.isEmpty) {
      return ResetResult(
        success: false,
        message: 'Email không tồn tại trong hệ thống',
      );
    }

    return ResetResult(
      success: true,
      message: 'Đã gửi mã xác nhận đến email của bạn',
    );
  }

  /// Verify reset code
  Future<ResetResult> verifyResetCode(String code) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (code == demoTotpCode || code.startsWith('1')) {
      return ResetResult(success: true, message: 'Mã xác thực đúng');
    }

    return ResetResult(success: false, message: 'Mã xác nhận không đúng');
  }

  /// Reset password
  Future<ResetResult> resetPassword(String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 800));

    return ResetResult(success: true, message: 'Đổi mật khẩu thành công');
  }

  /// Logout
  void logout() {
    _currentUser = null;
  }

  /// Update Profile
  Future<bool> updateProfile(User updatedUser) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = updatedUser;
    
    // In a real app we'd also update the user in the database/backend
    final index = _demoUsers.indexWhere((u) => u.username == updatedUser.username);
    if (index >= 0) {
      _demoUsers[index] = updatedUser;
    }
    
    return true;
  }

  /// Generate random secret key for TOTP
  String _generateSecretKey() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    final buffer = StringBuffer();
    for (var i = 0; i < 16; i++) {
      buffer.write(
        chars[(DateTime.now().millisecondsSinceEpoch + i) % chars.length],
      );
    }
    return buffer.toString();
  }
}

class LoginResult {
  final bool success;
  final String message;
  final bool requiresTOTP;

  LoginResult({
    required this.success,
    required this.message,
    this.requiresTOTP = false,
  });
}

class RegisterResult {
  final bool success;
  final String message;
  final String? totpSecret;

  RegisterResult({
    required this.success,
    required this.message,
    this.totpSecret,
  });
}

class ResetResult {
  final bool success;
  final String message;

  ResetResult({required this.success, required this.message});
}
