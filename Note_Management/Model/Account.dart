class Account {
  int id;
  int userId;
  String username;
  String password;
  String status;
  String? lastLogin;

  Account({
    required this.id,
    required this.userId,
    required this.username,
    required this.password,
    required this.status,
    this.lastLogin,
  });

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      userId: map['userId'],
      username: map['username'],
      password: map['password'],
      status: map['status'],
      lastLogin: map['lastLogin'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'password': password,
      'status': status,
      'lastLogin': lastLogin,
    };
  }
}
