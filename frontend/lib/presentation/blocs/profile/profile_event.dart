import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String token;
  LoadProfile(this.token);
  @override
  List<Object?> get props => [token];
}

class SignOutRequested extends ProfileEvent {
  final String token;
  SignOutRequested(this.token);
  @override
  List<Object?> get props => [token];
} 