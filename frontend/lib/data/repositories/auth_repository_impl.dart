import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_data_source.dart';
import '../datasources/cloud/fire_store_data_source.dart';
import '../datasources/remote/auth_remote_data_source.dart';
import '../../domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final FirestoreDataSource firestoreDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.firestoreDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.signIn(email, password);
        if (rememberMe) {
          await localDataSource.cacheUser(remoteUser);
        }
        await firestoreDataSource.saveUserData(remoteUser);
        return Right(remoteUser.toEntity());
      } on ServerException {
        return Left(ServerFailure());
      } on InvalidCredentialsException {
        return Left(InvalidCredentialsFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.signUp(email, password, name);
        await firestoreDataSource.saveUserData(remoteUser);
        return Right(remoteUser.toEntity());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final localUser = await localDataSource.getLastUser();
      if (localUser != null) {
        return Right(localUser.toEntity());
      }

      if (await networkInfo.isConnected) {
        final remoteUser = await remoteDataSource.getCurrentUser();
        if (remoteUser != null) {
          await localDataSource.cacheUser(remoteUser);
          return Right(remoteUser.toEntity());
        }
      }
      
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await localDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}