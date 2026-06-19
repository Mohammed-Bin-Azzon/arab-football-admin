class UserModel {
  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.followersCount,
    required this.followingCount,
  });

  final int id;
  final String username;
  final String email;
  final int followersCount;
  final int followingCount;

  factory UserModel.fromJson(dynamic json) {
    final map = Map<String, dynamic>.from(json as Map);

    int parseInt(dynamic value) {
      if (value is int) return value;
      return int.tryParse('$value') ?? 0;
    }

    return UserModel(
      id: parseInt(map['id'] ?? map['Id']),
      username: (map['username'] ?? map['Username'] ?? '').toString(),
      email: (map['email'] ?? map['Email'] ?? '').toString(),
      followersCount: parseInt(map['followersCount'] ?? map['FollowersCount']),
      followingCount: parseInt(map['followingCount'] ?? map['FollowingCount']),
    );
  }
}