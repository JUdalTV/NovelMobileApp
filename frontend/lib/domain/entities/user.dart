import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String? email;
  final String password;
  final String? token;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    this.token,
  });

  @override
  List<Object?> get props => [id, username, email, password, token];

  @override
  bool get stringify => true;
}