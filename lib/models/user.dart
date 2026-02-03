/// User model for authentication
class User {
  final String username;
  final String email;
  final String password;
  final String totpSecret;

  const User({
    required this.username,
    required this.email,
    required this.password,
    required this.totpSecret,
  });
}
