// lib/models/user.dart
class UserModel {
  final int? id;
  final String username;
  final String password;

  UserModel({this.id, required this.username, required this.password});

  Map<String, dynamic> toMap() => {'id': id, 'username': username, 'password': password};

  factory UserModel.fromMap(Map<String, dynamic> m) => UserModel(id: m['id'] as int?, username: m['username'] as String, password: m['password'] as String);
}
