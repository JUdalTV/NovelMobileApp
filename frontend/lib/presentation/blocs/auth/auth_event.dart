import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInEvent extends AuthEvent {
  final String username;
  final String password;

  const SignInEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}

class SignUpEvent extends AuthEvent {
  final String username;
  final String password;
  final String confirmPassword;

  const SignUpEvent({
    required this.username,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [username, password, confirmPassword];
}

class VerifyIdEvent extends AuthEvent {
  final String userId;
  final String idImagePath;

  const VerifyIdEvent({
    required this.userId,
    required this.idImagePath,
  });

  @override
  List<Object> get props => [userId, idImagePath];
}

class SignOutEvent extends AuthEvent {}