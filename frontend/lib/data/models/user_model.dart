import '../../domain/entities/user.dart';

class UserModel extends User {
  final String? email;
  final String? phoneNumber;
  final bool isVerified;

  const UserModel({
    required String id,
    required String username,
    required String password,
    this.email,
    this.phoneNumber,
    this.isVerified = false,
  }) : super(
          id: id,
          username: username,
          email: email,
          password: password,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      password: json['password'],
      isVerified: json['is_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone_number': phoneNumber,
      'password': password,
      'is_verified': isVerified,
    };
  }
}
