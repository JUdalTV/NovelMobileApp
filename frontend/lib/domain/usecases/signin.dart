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
    return await repository.signIn(
      email: params.email,
      password: params.password,
      rememberMe: params.rememberMe,
    );
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;
  final bool rememberMe;

  const SignInParams({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  @override
  List<Object> get props => [email, password];
}