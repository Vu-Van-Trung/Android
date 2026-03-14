import 'package:flutter/material.dart';
import '../../../widgets/gradient_background.dart';
import '../../../services/auth_service.dart';
import '../../../screens/login_screen.dart';
import '../widgets/profile_header.dart';
import '../widgets/menu_item.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'settings_screen.dart';

/// Màn hình tài khoản chính - hiển thị profile và menu điều hướng
class AccountScreen extends StatelessWidget {
  final AuthService authService;

  const AccountScreen({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser;

    return GradientBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Profile Header
              if (user != null)
                ProfileHeader(
                  user: user,
                  authService: authService,
                ),
              const SizedBox(height: 32),
              // Menu Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.06),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color.fromRGBO(255, 255, 255, 0.1),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    children: [
                      // Chỉnh sửa hồ sơ
                      AccountMenuItem(
                        icon: Icons.person_outline,
                        label: 'Chỉnh sửa hồ sơ',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(
                                authService: authService,
                              ),
                            ),
                          );
                        },
                      ),
                      // Đổi mật khẩu
                      AccountMenuItem(
                        icon: Icons.lock_outline,
                        label: 'Đổi mật khẩu',
                        iconColor: const Color(0xFF764BA2),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangePasswordScreen(
                                authService: authService,
                              ),
                            ),
                          );
                        },
                      ),
                      // Cài đặt
                      AccountMenuItem(
                        icon: Icons.settings_outlined,
                        label: 'Cài đặt',
                        iconColor: const Color(0xFF4ECDC4),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                      // Đăng xuất
                      AccountMenuItem(
                        icon: Icons.logout,
                        label: 'Đăng xuất',
                        isDanger: true,
                        showDivider: false,
                        onTap: () => _showLogoutDialog(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Phiên bản
              const Text(
                'DEMO Messenger v1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(255, 255, 255, 0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Đăng xuất',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn đăng xuất?',
          style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Hủy',
              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6)),
            ),
          ),
          TextButton(
            onPressed: () {
              authService.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
            child: const Text(
              'Đăng xuất',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
