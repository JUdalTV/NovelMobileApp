import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure([this.message = '']);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error']) : super(message);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure([String message = 'Invalid credentials']) 
    : super(message);
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure([String message = 'Email already in use']) 
    : super(message);
}

class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure([String message = 'Password is too weak']) 
    : super(message);
}

class InvalidEmailFailure extends Failure {
  const InvalidEmailFailure([String message = 'Invalid email format']) 
    : super(message);
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure([String message = 'User not found']) 
    : super(message);
}

class TooManyAttemptsFailure extends Failure {
  const TooManyAttemptsFailure([String message = 'Too many attempts, try again later']) 
    : super(message);
}
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error']) : super(message);
}
class UserAlreadyExistsFailure extends Failure {
  const UserAlreadyExistsFailure([String message = 'User already exists']) 
    : super(message);
}
class InvalidCredentials extends Failure {
  const InvalidCredentials([String message = 'Invalid credentials']) 
    : super(message);
}
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error']) : super(message);
}
class AuthenticationFailure extends Failure {
  const AuthenticationFailure([String message = 'Authentication error']) 
    : super(message);
}
class PermissionDeniedFailure extends Failure {
  const PermissionDeniedFailure([String message = 'Permission denied']) 
    : super(message);
}
class PasswordMismatchFailure extends Failure {
  const PasswordMismatchFailure([String message = 'Passwords do not match']) 
    : super(message);
}
class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'Unknown error']) : super(message);
}
class CacheError extends Failure {
  const CacheError([String message = 'Cache error']) : super(message);
}
class DatabaseError extends Failure {
  const DatabaseError([String message = 'Database error']) : super(message);
}
class TimeoutFailure extends Failure {
  const TimeoutFailure([String message = 'Request timed out']) : super(message);
}
class AuthFailure extends Failure {
  const AuthFailure([String message = 'Authentication error']) : super(message);
}