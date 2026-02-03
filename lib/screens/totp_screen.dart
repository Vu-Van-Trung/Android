import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../services/auth_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';
import 'success_screen.dart';

class TOTPScreen extends StatefulWidget {
  final AuthService authService;

  const TOTPScreen({super.key, required this.authService});

  @override
  State<TOTPScreen> createState() => _TOTPScreenState();
}

class _TOTPScreenState extends State<TOTPScreen>
    with SingleTickerProviderStateMixin {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  int _remainingSeconds = 30;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        _remainingSeconds--;
        if (_remainingSeconds <= 0) {
          _remainingSeconds = 30;
        }
      });
      return true;
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    if (_codeController.text.length != 6) {
      setState(() => _errorMessage = 'Vui lòng nhập đủ 6 số');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await widget.authService.verifyTOTP(_codeController.text);

    setState(() => _isLoading = false);

    if (result.success) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SuccessScreen(
              title: 'Đăng nhập thành công!',
              message: 'Chào mừng bạn đã quay trở lại',
            ),
          ),
          (route) => false,
        );
      }
    } else {
      setState(() {
        _errorMessage = result.message;
        _codeController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: GlassCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Back button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Quay lại'),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Step indicator
                      _buildStepIndicator(),
                      const SizedBox(height: 24),

                      // Logo
                      _buildLogo(),
                      const SizedBox(height: 24),

                      // Title
                      Text(
                        'Xác thực TOTP',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nhập mã 6 số từ ứng dụng xác thực',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color.fromRGBO(255, 255, 255, 0.7),
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Error message
                      if (_errorMessage != null) ...[
                        _buildErrorAlert(),
                        const SizedBox(height: 16),
                      ],

                      // PIN code input
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12),
                          fieldHeight: 56,
                          fieldWidth: 44,
                          activeFillColor:
                              const Color.fromRGBO(255, 255, 255, 0.1),
                          inactiveFillColor:
                              const Color.fromRGBO(255, 255, 255, 0.05),
                          selectedFillColor:
                              const Color.fromRGBO(255, 255, 255, 0.1),
                          activeColor: const Color(0xFF667EEA),
                          inactiveColor:
                              const Color.fromRGBO(255, 255, 255, 0.2),
                          selectedColor: const Color(0xFF667EEA),
                        ),
                        enableActiveFill: true,
                        cursorColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        onCompleted: (value) {
                          _handleVerify();
                        },
                        onChanged: (value) {
                          setState(() => _errorMessage = null);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Timer
                      Text(
                        'Mã hết hạn sau $_remainingSeconds giây',
                        style: const TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.5),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Verify button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleVerify,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Xác nhận'),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Resend link
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã gửi lại mã xác thực'),
                            ),
                          );
                        },
                        child: const Text('Không nhận được mã? Gửi lại'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepDot(completed: true),
        const SizedBox(width: 8),
        _buildStepDot(active: true),
      ],
    );
  }

  Widget _buildStepDot({bool active = false, bool completed = false}) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: (active || completed)
            ? const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              )
            : null,
        color: (active || completed)
            ? null
            : const Color.fromRGBO(255, 255, 255, 0.2),
        boxShadow: active
            ? const [
                BoxShadow(
                  color: Color.fromRGBO(102, 126, 234, 0.5),
                  blurRadius: 12,
                ),
              ]
            : null,
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

  Widget _buildErrorAlert() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(239, 68, 68, 0.15),
        border: Border.all(
          color: const Color.fromRGBO(239, 68, 68, 0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFFCA5A5),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: Color(0xFFFCA5A5),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
