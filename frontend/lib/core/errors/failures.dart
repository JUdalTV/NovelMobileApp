import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// Các loại lỗi chung
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

// Các lỗi liên quan đến Authentication
class InvalidCredentialsFailure extends Failure {}

class UserAlreadyExistsFailure extends Failure {}

class WeakPasswordFailure extends Failure {}

class PasswordMismatchFailure extends Failure {}

class VerificationFailure extends Failure {}