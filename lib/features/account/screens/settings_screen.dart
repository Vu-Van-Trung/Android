import 'package:flutter/material.dart';
import '../../../widgets/gradient_background.dart';
import '../../../services/settings_service.dart';

/// Màn hình cài đặt ứng dụng
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine current theme colors
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? const Color.fromRGBO(255, 255, 255, 0.5) : const Color.fromRGBO(0, 0, 0, 0.5);
    final borderColor = isDark ? const Color.fromRGBO(255, 255, 255, 0.1) : const Color.fromRGBO(0, 0, 0, 0.1);
    final cardColor = isDark ? const Color.fromRGBO(255, 255, 255, 0.06) : const Color.fromRGBO(0, 0, 0, 0.04);
    final dividerColor = isDark ? const Color.fromRGBO(255, 255, 255, 0.08) : const Color.fromRGBO(0, 0, 0, 0.06);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt', style: TextStyle(color: textColor)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: GradientBackground(
        child: SafeArea(
          child: ListenableBuilder(
            listenable: SettingsService(),
            builder: (context, _) {
              final settings = SettingsService();
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                children: [
                  // === Thông báo ===
                  _buildSectionHeader('Thông báo', Icons.notifications_outlined, subtitleColor),
                  const SizedBox(height: 8),
                  _buildSettingsCard(cardColor, borderColor, [
                    _buildSwitchTile(
                      icon: Icons.message_outlined,
                      title: 'Thông báo tin nhắn',
                      subtitle: 'Nhận thông báo khi có tin nhắn mới',
                      value: settings.messageNotification,
                      onChanged: (val) => settings.updateMessageNotification(val),
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                    _buildDivider(dividerColor),
                    _buildSwitchTile(
                      icon: Icons.volume_up_outlined,
                      title: 'Âm thanh thông báo',
                      subtitle: 'Phát âm thanh khi nhận thông báo',
                      value: settings.soundNotification,
                      onChanged: (val) => settings.updateSoundNotification(val),
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                    _buildDivider(dividerColor),
                    _buildSwitchTile(
                      icon: Icons.vibration,
                      title: 'Rung',
                      subtitle: 'Rung khi nhận thông báo',
                      value: settings.vibration,
                      onChanged: (val) => settings.updateVibration(val),
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // === Bảo mật ===
                  _buildSectionHeader('Bảo mật', Icons.shield_outlined, subtitleColor),
                  const SizedBox(height: 8),
                  _buildSettingsCard(cardColor, borderColor, [
                    _buildSwitchTile(
                      icon: Icons.fingerprint,
                      title: 'Đăng nhập bằng vân tay',
                      subtitle: 'Sử dụng vân tay để mở khóa ứng dụng',
                      value: settings.fingerprintLogin,
                      onChanged: (val) => settings.updateFingerprintLogin(val),
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                    _buildDivider(dividerColor),
                    _buildSwitchTile(
                      icon: Icons.security,
                      title: 'Xác thực hai bước (TOTP)',
                      subtitle: 'Bảo vệ tài khoản bằng mã xác thực',
                      value: settings.twoFactorAuth,
                      onChanged: (val) => settings.updateTwoFactorAuth(val),
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // === Giao diện ===
                  _buildSectionHeader('Giao diện', Icons.palette_outlined, subtitleColor),
                  const SizedBox(height: 8),
                  _buildSettingsCard(cardColor, borderColor, [
                    _buildSwitchTile(
                      icon: Icons.dark_mode_outlined,
                      title: 'Chế độ tối',
                      subtitle: 'Sử dụng giao diện tối',
                      value: settings.darkMode,
                      onChanged: (val) => settings.updateDarkMode(val),
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // === Thông tin ứng dụng ===
                  _buildSectionHeader('Thông tin', Icons.info_outline, subtitleColor),
                  const SizedBox(height: 8),
                  _buildSettingsCard(cardColor, borderColor, [
                    _buildInfoTile(
                      icon: Icons.apps,
                      title: 'Phiên bản',
                      value: 'v1.0.0',
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                    _buildDivider(dividerColor),
                    _buildInfoTile(
                      icon: Icons.code,
                      title: 'Build',
                      value: '2026.03.14',
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                  ]),
                  const SizedBox(height: 32),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color subtitleColor) {
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
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: subtitleColor,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(Color cardColor, Color borderColor, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
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
    required Color textColor,
    required Color subtitleColor,
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
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: subtitleColor,
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
            inactiveThumbColor: subtitleColor,
            inactiveTrackColor: subtitleColor.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required Color textColor,
    required Color subtitleColor,
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
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(Color dividerColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        color: dividerColor,
        height: 1,
      ),
    );
  }
}
