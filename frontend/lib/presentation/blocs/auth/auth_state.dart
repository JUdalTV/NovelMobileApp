import 'package:equatable/equatable.dart';

import '../../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  
  const Authenticated(this.user);
  
  @override
  List<Object> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  
  const AuthError(this.message);
  
  @override
  List<Object> get props => [message];
}

class SignInError extends AuthState {
  final String message;
  
  const SignInError(this.message);
  
  @override
  List<Object> get props => [message];
}

class SignUpError extends AuthState {
  final String message;
  
  const SignUpError(this.message);
  
  @override
  List<Object> get props => [message];
}

class VerificationError extends AuthState {
  final String message;
  
  const VerificationError(this.message);
  
  @override
  List<Object> get props => [message];
}

class SignUpSuccess extends AuthState {}

class VerificationSuccess extends AuthState {}