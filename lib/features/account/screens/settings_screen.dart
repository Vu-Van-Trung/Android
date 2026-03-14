import 'package:flutter/material.dart';
import '../../../widgets/gradient_background.dart';

/// Màn hình cài đặt ứng dụng
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Thông báo
  bool _messageNotification = true;
  bool _soundNotification = true;
  bool _vibration = true;

  // Bảo mật
  bool _fingerprintLogin = false;
  bool _twoFactorAuth = true;

  // Giao diện
  bool _darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GradientBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              // === Thông báo ===
              _buildSectionHeader('Thông báo', Icons.notifications_outlined),
              const SizedBox(height: 8),
              _buildSettingsCard([
                _buildSwitchTile(
                  icon: Icons.message_outlined,
                  title: 'Thông báo tin nhắn',
                  subtitle: 'Nhận thông báo khi có tin nhắn mới',
                  value: _messageNotification,
                  onChanged: (val) =>
                      setState(() => _messageNotification = val),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.volume_up_outlined,
                  title: 'Âm thanh thông báo',
                  subtitle: 'Phát âm thanh khi nhận thông báo',
                  value: _soundNotification,
                  onChanged: (val) =>
                      setState(() => _soundNotification = val),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.vibration,
                  title: 'Rung',
                  subtitle: 'Rung khi nhận thông báo',
                  value: _vibration,
                  onChanged: (val) => setState(() => _vibration = val),
                ),
              ]),
              const SizedBox(height: 24),

              // === Bảo mật ===
              _buildSectionHeader('Bảo mật', Icons.shield_outlined),
              const SizedBox(height: 8),
              _buildSettingsCard([
                _buildSwitchTile(
                  icon: Icons.fingerprint,
                  title: 'Đăng nhập bằng vân tay',
                  subtitle: 'Sử dụng vân tay để mở khóa ứng dụng',
                  value: _fingerprintLogin,
                  onChanged: (val) =>
                      setState(() => _fingerprintLogin = val),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.security,
                  title: 'Xác thực hai bước (TOTP)',
                  subtitle: 'Bảo vệ tài khoản bằng mã xác thực',
                  value: _twoFactorAuth,
                  onChanged: (val) =>
                      setState(() => _twoFactorAuth = val),
                ),
              ]),
              const SizedBox(height: 24),

              // === Giao diện ===
              _buildSectionHeader('Giao diện', Icons.palette_outlined),
              const SizedBox(height: 8),
              _buildSettingsCard([
                _buildSwitchTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Chế độ tối',
                  subtitle: 'Sử dụng giao diện tối',
                  value: _darkMode,
                  onChanged: (val) => setState(() => _darkMode = val),
                ),
              ]),
              const SizedBox(height: 24),

              // === Thông tin ứng dụng ===
              _buildSectionHeader('Thông tin', Icons.info_outline),
              const SizedBox(height: 8),
              _buildSettingsCard([
                _buildInfoTile(
                  icon: Icons.apps,
                  title: 'Phiên bản',
                  value: 'v1.0.0',
                ),
                _buildDivider(),
                _buildInfoTile(
                  icon: Icons.code,
                  title: 'Build',
                  value: '2026.03.14',
                ),
              ]),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF667EEA),
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(255, 255, 255, 0.5),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromRGBO(255, 255, 255, 0.1),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF667EEA), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromRGBO(255, 255, 255, 0.5),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF667EEA),
            activeTrackColor: const Color(0xFF667EEA).withValues(alpha: 0.3),
            inactiveThumbColor: const Color.fromRGBO(255, 255, 255, 0.4),
            inactiveTrackColor: const Color.fromRGBO(255, 255, 255, 0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF667EEA), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromRGBO(255, 255, 255, 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        color: Color.fromRGBO(255, 255, 255, 0.08),
        height: 1,
      ),
    );
  }
}
