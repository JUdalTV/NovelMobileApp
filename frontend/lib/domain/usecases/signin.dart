import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';


import '../../core/errors/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignIn implements UseCase<User, SignInParams> {
  final AuthRepository repository;

  SignIn(this.repository);

  @override
  Future<Either<Failure, User>> call(SignInParams params) async {
    return await repository.signIn(params.username, params.password);
  }
}

class SignInParams extends Equatable {
  final String username;
  final String password;

  const SignInParams({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}