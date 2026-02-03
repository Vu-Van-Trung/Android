import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';
import 'success_screen.dart';

class TOTPSetupScreen extends StatelessWidget {
  final String secretKey;

  const TOTPSetupScreen({super.key, required this.secretKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: GlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    _buildLogo(),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      'Thiết lập TOTP',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Quét mã QR bằng ứng dụng xác thực\n(Google Authenticator, Authy...)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color.fromRGBO(255, 255, 255, 0.7),
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // QR Code placeholder
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code_2,
                              size: 100,
                              color: Colors.grey[800],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Demo QR',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Secret key
                    const Text(
                      'Hoặc nhập mã thủ công:',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.5),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255, 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        secretKey,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Warning
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(245, 158, 11, 0.15),
                        border: Border.all(
                          color: const Color.fromRGBO(245, 158, 11, 0.3),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Color(0xFFFCD34D),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Hãy lưu mã bí mật này ở nơi an toàn',
                              style: TextStyle(
                                color: Colors.amber[200],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Complete button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SuccessScreen(
                                title: 'Đăng ký thành công!',
                                message:
                                    'Tài khoản của bạn đã được tạo và kích hoạt',
                                showLoginButton: true,
                              ),
                            ),
                          );
                        },
                        child: const Text('Hoàn tất đăng ký'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(102, 126, 234, 0.4),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(
        Icons.lock_outline,
        color: Colors.white,
        size: 36,
      ),
    );
  }
}
