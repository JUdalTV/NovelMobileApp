import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;

  const SignInRequested({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  @override
  List<Object> get props => [email, password, rememberMe];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const SignUpRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object> get props => [email, password, name];
}

class SignOutRequested extends AuthEvent {}

class AutoSignInEvent extends AuthEvent {
  final String token;

  const AutoSignInEvent({required this.token, required String email});

  @override
  List<Object> get props => [token];
}

class CheckAuthStatusEvent extends AuthEvent {}

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