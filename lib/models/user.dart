/// User model for authentication
class User {
  final String username;
  final String email;
  final String password;
  final String totpSecret;
  
  // New optional profile fields
  final String? fullName;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? avatarPath;
  final String? coverPath;

  const User({
    required this.username,
    required this.email,
    required this.password,
    required this.totpSecret,
    this.fullName,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.avatarPath,
    this.coverPath,
  });

  // Helper method to create a copy of User with updated fields
  User copyWith({
    String? username,
    String? email,
    String? password,
    String? totpSecret,
    String? fullName,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? gender,
    String? avatarPath,
    String? coverPath,
  }) {
    return User(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      totpSecret: totpSecret ?? this.totpSecret,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      avatarPath: avatarPath ?? this.avatarPath,
      coverPath: coverPath ?? this.coverPath,
    );
  }
}
