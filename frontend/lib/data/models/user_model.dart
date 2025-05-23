import '../../domain/entities/user.dart';

class UserModel {
  final String? id;
  final String? email;
  final String? username;
  final bool isVerified;
  final String? token;

  UserModel({
    this.id,
    this.email,
    this.username,
    this.isVerified = false,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'is_verified': isVerified,
      'token': token,
    };
  }

  User toEntity() {
    return User(
      id: id,
      username: username,
      email: email,
      // avatar, role, createdAt, updatedAt không có trong UserModel, nếu cần thì bổ sung thêm field vào UserModel
    );
  }
}