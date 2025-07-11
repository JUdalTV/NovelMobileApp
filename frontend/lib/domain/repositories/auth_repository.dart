import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {

  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  });

  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, void>> signOut();
  
  Future<Either<Failure, User?>> getCurrentUser();
}

