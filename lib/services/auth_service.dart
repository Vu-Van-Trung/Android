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
  ];

  // Demo TOTP code (in production, would use real TOTP algorithm)
  static const String demoTotpCode = '123456';

  User? _currentUser;

  User? get currentUser => _currentUser;

  /// Login with username/email and password
  Future<LoginResult> login(String usernameOrEmail, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final user = _demoUsers.firstWhere(
      (u) =>
          (u.username == usernameOrEmail || u.email == usernameOrEmail) &&
          u.password == password,
      orElse: () =>
          const User(username: '', email: '', password: '', totpSecret: ''),
    );

    if (user.username.isEmpty) {
      return LoginResult(
        success: false,
        message: 'Tên đăng nhập hoặc mật khẩu không đúng',
      );
    }

    _currentUser = user;
    return LoginResult(
      success: true,
      message: 'Đăng nhập thành công, vui lòng xác thực TOTP',
      requiresTOTP: true,
    );
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
    await Future.delayed(const Duration(milliseconds: 1000));

    // Check if user exists
    final exists = _demoUsers.any(
      (u) => u.username == username || u.email == email,
    );

    if (exists) {
      return RegisterResult(
        success: false,
        message: 'Tên đăng nhập hoặc email đã tồn tại',
      );
    }

    // Generate secret key
    final secretKey = _generateSecretKey();

    return RegisterResult(
      success: true,
      message: 'Đăng ký thành công',
      totpSecret: secretKey,
    );
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
