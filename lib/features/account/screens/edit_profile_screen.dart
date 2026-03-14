import 'package:flutter/material.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/glass_card.dart';
import '../../../services/auth_service.dart';

/// Màn hình chỉnh sửa thông tin cá nhân
class EditProfileScreen extends StatefulWidget {
  final AuthService authService;

  const EditProfileScreen({super.key, required this.authService});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  
  DateTime? _selectedDate;
  String? _selectedGender;
  final List<String> _genders = ['Nam', 'Nữ', 'Khác'];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = widget.authService.currentUser;
    _usernameController = TextEditingController(text: user?.username ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _fullNameController = TextEditingController(text: user?.fullName ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    _selectedDate = user?.dateOfBirth;
    _selectedGender = user?.gender;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final currentUser = widget.authService.currentUser;
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        fullName: _fullNameController.text.trim().isEmpty ? null : _fullNameController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        dateOfBirth: _selectedDate,
        gender: _selectedGender,
      );

      await widget.authService.updateProfile(updatedUser);
    } else {
      await Future.delayed(const Duration(milliseconds: 800));
    }

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật hồ sơ thành công!'),
          backgroundColor: Color(0xFF667EEA),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa hồ sơ'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: GlassCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thông tin cá nhân',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Cập nhật thông tin hồ sơ của bạn',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(255, 255, 255, 0.6),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Tên đăng nhập
                      TextFormField(
                        controller: _usernameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Tên đăng nhập',
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Color.fromRGBO(255, 255, 255, 0.6),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập tên đăng nhập';
                          }
                          if (value.trim().length < 3) {
                            return 'Tên đăng nhập phải có ít nhất 3 ký tự';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Họ và tên
                      TextFormField(
                        controller: _fullNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Họ và tên',
                          prefixIcon: Icon(
                            Icons.badge_outlined,
                            color: Color.fromRGBO(255, 255, 255, 0.6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Email
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Color.fromRGBO(255, 255, 255, 0.6),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                              .hasMatch(value.trim())) {
                            return 'Email không hợp lệ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Số điện thoại
                      TextFormField(
                        controller: _phoneController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Số điện thoại',
                          prefixIcon: Icon(
                            Icons.phone_outlined,
                            color: Color.fromRGBO(255, 255, 255, 0.6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Ngày sinh & Giới tính row
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedDate ?? DateTime(2000),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (date != null) {
                                  setState(() => _selectedDate = date);
                                }
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Ngày sinh',
                                  prefixIcon: Icon(
                                    Icons.calendar_today_outlined,
                                    color: Color.fromRGBO(255, 255, 255, 0.6),
                                  ),
                                ),
                                child: Text(
                                  _selectedDate != null
                                      ? '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}'
                                      : 'Chọn ngày',
                                  style: TextStyle(
                                    color: _selectedDate != null
                                        ? Colors.white
                                        : const Color.fromRGBO(255, 255, 255, 0.6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              // ignore: deprecated_member_use
                              value: _selectedGender,
                              dropdownColor: const Color(0xFF1A1A2E),
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Giới tính',
                                prefixIcon: Icon(
                                  Icons.people_outline,
                                  color: Color.fromRGBO(255, 255, 255, 0.6),
                                ),
                              ),
                              items: _genders.map((gender) {
                                return DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() => _selectedGender = value);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Nút lưu
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF667EEA),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Lưu thay đổi',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
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
}
