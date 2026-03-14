import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/user.dart';
import '../../../services/auth_service.dart';

/// Widget hiển thị ảnh bìa, avatar và thông tin profile user
class ProfileHeader extends StatefulWidget {
  final User user;
  final AuthService authService;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.authService,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  String? _avatarPath;
  String? _coverPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _avatarPath = widget.user.avatarPath;
    _coverPath = widget.user.coverPath;
  }

  Future<void> _pickImage(bool isAvatar) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          if (isAvatar) {
            _avatarPath = image.path;
          } else {
            _coverPath = image.path;
          }
        });

        // Update user model via AuthService
        final updatedUser = widget.user.copyWith(
          avatarPath: isAvatar ? image.path : _avatarPath,
          coverPath: !isAvatar ? image.path : _coverPath,
        );
        await widget.authService.updateProfile(updatedUser);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String initial = widget.user.fullName?.isNotEmpty == true
        ? widget.user.fullName![0].toUpperCase()
        : (widget.user.username.isNotEmpty ? widget.user.username[0].toUpperCase() : '?');
    
    final String displayName = widget.user.fullName?.isNotEmpty == true 
        ? widget.user.fullName! 
        : widget.user.username;

    return Column(
      children: [
        // Cover and Avatar Stack
        SizedBox(
          height: 200,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Cover Photo
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 140,
                child: GestureDetector(
                  onTap: () => _pickImage(false),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(255, 255, 255, 0.05),
                      image: _coverPath != null
                          ? DecorationImage(
                              image: FileImage(File(_coverPath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                      border: Border.all(
                        color: const Color.fromRGBO(255, 255, 255, 0.1),
                      ),
                    ),
                    child: _coverPath == null
                        ? const Center(
                            child: Icon(
                              Icons.add_photo_alternate_outlined,
                              color: Color.fromRGBO(255, 255, 255, 0.3),
                              size: 40,
                            ),
                          )
                        : null,
                  ),
                ),
              ),

              // Camera Icon for Cover
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () => _pickImage(false),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),

              // Avatar
              Positioned(
                bottom: 0,
                child: GestureDetector(
                  onTap: () => _pickImage(true),
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF1A1A2E), // Match app background to act as border
                          border: Border.all(
                            color: const Color(0xFF1A1A2E),
                            width: 4,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: _avatarPath == null
                                ? const LinearGradient(
                                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            image: _avatarPath != null
                                ? DecorationImage(
                                    image: FileImage(File(_avatarPath!)),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _avatarPath == null
                              ? Center(
                                  child: Text(
                                    initial,
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ),
                      // Camera Icon for Avatar
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF667EEA),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF1A1A2E),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        // Tên người dùng (ưu tiên Full Name)
        Text(
          displayName,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        // Email
        Text(
          widget.user.email,
          style: const TextStyle(
            fontSize: 14,
            color: Color.fromRGBO(255, 255, 255, 0.6),
          ),
        ),
      ],
    );
  }
}
