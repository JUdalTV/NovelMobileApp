import '../entities/reading_history.dart';
import '../entities/novel.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<List<ReadingHistory>> getReadingHistory(String token);
  Future<List<Novel>> getReadNovels(String token);
  Future<List<Novel>> getFavoriteNovels(String token);
  Future<void> updateReadingTime(String token, String novelId, int minutes);
  Future<void> favoriteNovel(String token, String novelId);
  Future<void> unfavoriteNovel(String token, String novelId);
  Future<void> signOut(String token);
  Future<User> getCurrentUser(String token);
  Future<User> updateProfile(String token, String username, String? avatar);
  Future<void> changePassword(String token, String currentPassword, String newPassword);
  Future<List<User>> getUsers(String token);
  Future<User> getUserById(String token, String id);
  Future<void> deleteUser(String token, String id);
  Future<void> updateUserRole(String token, String id, String role);
} 