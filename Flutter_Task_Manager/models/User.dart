class User {
  final String id;
  final String username;
  final String email;
  final String password;
  final String avatar;
  final DateTime createdAt;
  final DateTime lastLogin;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.avatar,
    required this.createdAt,
    required this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['_id'] ?? '',
    username: json['username'] ?? '',
    email: json['email'] ?? '',
    password: json['password'] ?? "",
    avatar: json['avatar'] ?? '',
    createdAt: json['createdAt'] != null && json['createdAt'].isNotEmpty
        ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
        : DateTime.now(),
    lastLogin: json['lastLogin'] != null && json['lastLogin'].isNotEmpty
        ? DateTime.tryParse(json['lastLogin']) ?? DateTime.now()
        : DateTime.now(),
  );


  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'password': password,
    'avatar': avatar,
    'createdAt': createdAt.toIso8601String(),
    'lastLogin': lastLogin.toIso8601String(),
  };
}
