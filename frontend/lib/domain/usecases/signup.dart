import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUp implements UseCase<User, SignUpParams> {
  final AuthRepository repository;

  SignUp(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await repository.signUp(params.username, params.password, params.confirmPassword);
  }
}

class SignUpParams extends Equatable {
  final String username;
  final String password;
  final String confirmPassword;

  const SignUpParams({
    required this.username,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [username, password, confirmPassword];
} 