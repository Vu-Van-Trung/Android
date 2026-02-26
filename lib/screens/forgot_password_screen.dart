import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../services/auth_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';
import 'success_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _authService = AuthService();

  // Controllers
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State
  int _currentStep = 0; // 0: email, 1: verify, 2: new password
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  String _sentEmail = '';

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSendCode() async {
    if (_emailController.text.isEmpty) {
      setState(() => _errorMessage = 'Vui lòng nhập email');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result =
        await _authService.requestPasswordReset(_emailController.text.trim());

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      if (mounted) {
        setState(() {
          _sentEmail = _emailController.text.trim();
          _currentStep = 1;
        });
      }
    } else {
      if (mounted) {
        setState(() => _errorMessage = result.message);
      }
    }
  }

  Future<void> _handleVerifyCode() async {
    if (_codeController.text.length != 6) {
      setState(() => _errorMessage = 'Vui lòng nhập đủ 6 số');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authService.verifyResetCode(_codeController.text);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      if (mounted) {
        setState(() => _currentStep = 2);
      }
    } else {
      if (mounted) {
        setState(() {
          _errorMessage = result.message;
          _codeController.clear();
        });
      }
    }
  }

  Future<void> _handleResetPassword() async {
    if (_newPasswordController.text.length < 8) {
      setState(() => _errorMessage = 'Mật khẩu phải có ít nhất 8 ký tự');
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Mật khẩu xác nhận không khớp');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result =
        await _authService.resetPassword(_newPasswordController.text);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SuccessScreen(
              title: 'Đổi mật khẩu thành công!',
              message: 'Bạn có thể đăng nhập với mật khẩu mới',
              showLoginButton: true,
            ),
          ),
        );
      }
    } else {
      if (mounted) {
        setState(() => _errorMessage = result.message);
      }
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
              child: GlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          if (_currentStep > 0) {
                            setState(() {
                              _currentStep--;
                              _errorMessage = null;
                            });
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: Text(_currentStep == 0
                            ? 'Quay lại đăng nhập'
                            : 'Quay lại'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Step indicator
                    _buildStepIndicator(),
                    const SizedBox(height: 24),

                    // Content based on step
                    if (_currentStep == 0) _buildEmailStep(),
                    if (_currentStep == 1) _buildVerifyStep(),
                    if (_currentStep == 2) _buildNewPasswordStep(),
                  ],
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
        _buildStepDot(active: _currentStep == 0, completed: _currentStep > 0),
        const SizedBox(width: 8),
        _buildStepDot(active: _currentStep == 1, completed: _currentStep > 1),
        const SizedBox(width: 8),
        _buildStepDot(active: _currentStep == 2),
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

  Widget _buildEmailStep() {
    return Column(
      children: [
        _buildLogo(Icons.security),
        const SizedBox(height: 24),
        Text(
          'Quên mật khẩu?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Nhập email để nhận mã xác nhận',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color.fromRGBO(255, 255, 255, 0.7),
              ),
        ),
        const SizedBox(height: 32),
        if (_errorMessage != null) ...[
          _buildErrorAlert(),
          const SizedBox(height: 16),
        ],
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'Nhập địa chỉ email đã đăng ký',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleSendCode,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Gửi mã xác nhận'),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyStep() {
    return Column(
      children: [
        _buildLogo(Icons.email_outlined),
        const SizedBox(height: 24),
        Text(
          'Kiểm tra email',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            text: 'Chúng tôi đã gửi mã đến ',
            children: [
              TextSpan(
                text: _sentEmail,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color.fromRGBO(255, 255, 255, 0.7),
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        if (_errorMessage != null) ...[
          _buildErrorAlert(),
          const SizedBox(height: 16),
        ],
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
            activeFillColor: const Color.fromRGBO(255, 255, 255, 0.1),
            inactiveFillColor: const Color.fromRGBO(255, 255, 255, 0.05),
            selectedFillColor: const Color.fromRGBO(255, 255, 255, 0.1),
            activeColor: const Color(0xFF667EEA),
            inactiveColor: const Color.fromRGBO(255, 255, 255, 0.2),
            selectedColor: const Color(0xFF667EEA),
          ),
          enableActiveFill: true,
          cursorColor: Colors.white,
          textStyle: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          onCompleted: (value) => _handleVerifyCode(),
          onChanged: (value) => setState(() => _errorMessage = null),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleVerifyCode,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Xác nhận'),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {},
          child: const Text('Không nhận được email? Gửi lại'),
        ),
      ],
    );
  }

  Widget _buildNewPasswordStep() {
    return Column(
      children: [
        _buildLogo(Icons.lock_outline),
        const SizedBox(height: 24),
        Text(
          'Tạo mật khẩu mới',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Nhập mật khẩu mới cho tài khoản',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color.fromRGBO(255, 255, 255, 0.7),
              ),
        ),
        const SizedBox(height: 32),
        if (_errorMessage != null) ...[
          _buildErrorAlert(),
          const SizedBox(height: 16),
        ],
        TextFormField(
          controller: _newPasswordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Mật khẩu mới',
            hintText: 'Ít nhất 8 ký tự',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Xác nhận mật khẩu',
            hintText: 'Nhập lại mật khẩu mới',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirmPassword
                  ? Icons.visibility_off
                  : Icons.visibility),
              onPressed: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleResetPassword,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Đổi mật khẩu'),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo(IconData icon) {
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
      child: Icon(icon, color: Colors.white, size: 36),
    );
  }

  Widget _buildErrorAlert() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(239, 68, 68, 0.15),
        border: Border.all(color: const Color.fromRGBO(239, 68, 68, 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFFCA5A5), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Color(0xFFFCA5A5), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
