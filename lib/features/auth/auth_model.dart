class AuthModel {
  const AuthModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.role,
    required this.token,
  });

  final int userId;
  final String username;
  final String email;
  final String role;
  final String token;

  factory AuthModel.fromJson(dynamic json) {
    final map = Map<String, dynamic>.from(json as Map);

    return AuthModel(
      userId: map['userId'] ?? map['UserId'] ?? 0,
      username: (map['username'] ?? map['Username'] ?? '').toString(),
      email: (map['email'] ?? map['Email'] ?? '').toString(),
      role: (map['role'] ?? map['Role'] ?? '').toString(),
      token: (map['token'] ?? map['Token'] ?? '').toString(),
    );
  }

  bool get isAdmin => role.toLowerCase() == 'admin';
}