import 'package:frontend/domain/entities/novel.dart';
import 'package:frontend/domain/entities/reading_history.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<User> getCurrentUser(String token) async {
    final userModel = await remoteDataSource.getCurrentUser(token);
    return userModel.toEntity();
  }

  @override
  Future<User> updateProfile(String token, String username, String? avatar) async {
    final userModel = await remoteDataSource.updateProfile(token, username, avatar);
    return userModel.toEntity();
  }

  @override
  Future<void> changePassword(String token, String currentPassword, String newPassword) async {
    await remoteDataSource.changePassword(token, currentPassword, newPassword);
  }

  @override
  Future<List<User>> getUsers(String token) async {
    final result = await remoteDataSource.getUsers(token);
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<User> getUserById(String token, String id) async {
    final userModel = await remoteDataSource.getUserById(token, id);
    return userModel.toEntity();
  }

  @override
  Future<void> deleteUser(String token, String id) async {
    await remoteDataSource.deleteUser(token, id);
  }

  @override
  Future<void> updateUserRole(String token, String id, String role) async {
    await remoteDataSource.updateUserRole(token, id, role);
  }

  @override
  Future<List<ReadingHistory>> getReadingHistory(String token) async {
    final result = await remoteDataSource.getReadingHistory(token);
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<Novel>> getReadNovels(String token) async {
    final result = await remoteDataSource.getReadNovels(token);
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<Novel>> getFavoriteNovels(String token) async {
    final result = await remoteDataSource.getFavoriteNovels(token);
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> updateReadingTime(String token, String novelId, int minutes) async {
    await remoteDataSource.updateReadingTime(token, novelId, minutes);
  }

  @override
  Future<void> favoriteNovel(String token, String novelId) async {
    await remoteDataSource.favoriteNovel(token, novelId);
  }

  @override
  Future<void> unfavoriteNovel(String token, String novelId) async {
    await remoteDataSource.unfavoriteNovel(token, novelId);
  }

  @override
  Future<void> signOut(String token) async {
    await remoteDataSource.signOut(token);
  }
} 