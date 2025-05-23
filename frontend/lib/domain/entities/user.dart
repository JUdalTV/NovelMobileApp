import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String? username;
  final String? email;
  final String? avatar;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    this.id,
    this.username,
    this.email,
    this.avatar,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, username, email, avatar, role, createdAt, updatedAt];

  @override
  bool get stringify => true;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar': avatar,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      avatar: json['avatar'],
      role: json['role'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}