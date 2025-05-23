import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/reading_history_model.dart';
import '../../models/favorite_novel_model.dart';
import '../../models/novel_model.dart';
import '../../models/user_model.dart';

class UserRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  UserRemoteDataSource({required this.client, required this.baseUrl});

  Future<List<ReadingHistoryModel>> getReadingHistory(String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/user/reading-history'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => ReadingHistoryModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load reading history');
    }
  }

  Future<List<NovelModel>> getReadNovels(String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/user/read-novels'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => NovelModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load read novels');
    }
  }

  Future<List<FavoriteNovelModel>> getFavoriteNovels(String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/user/favorites'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => FavoriteNovelModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load favorite novels');
    }
  }

  Future<void> updateReadingTime(String token, String novelId, int minutes) async {
    final response = await client.post(
      Uri.parse('$baseUrl/user/update-reading-time'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: json.encode({'novelId': novelId, 'minutes': minutes}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update reading time');
    }
  }

  Future<void> favoriteNovel(String token, String novelId) async {
    final response = await client.post(
      Uri.parse('$baseUrl/user/favorite'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: json.encode({'novelId': novelId}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to favorite novel');
    }
  }

  Future<void> unfavoriteNovel(String token, String novelId) async {
    final response = await client.post(
      Uri.parse('$baseUrl/user/unfavorite'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: json.encode({'novelId': novelId}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to unfavorite novel');
    }
  }

  Future<void> signOut(String token) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to sign out');
    }
  }

  Future<UserModel> getCurrentUser(String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/user/me'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to get current user');
    }
  }

  Future<UserModel> updateProfile(String token, String username, String? avatar) async {
    final response = await client.put(
      Uri.parse('$baseUrl/user/profile'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'avatar': avatar}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to update profile');
    }
  }

  Future<void> changePassword(String token, String currentPassword, String newPassword) async {
    final response = await client.post(
      Uri.parse('$baseUrl/user/change-password'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: json.encode({'currentPassword': currentPassword, 'newPassword': newPassword}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to change password');
    }
  }

  Future<List<UserModel>> getUsers(String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/user/all'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get users');
    }
  }

  Future<UserModel> getUserById(String token, String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/user/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to get user by id');
    }
  }

  Future<void> deleteUser(String token, String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/user/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  Future<void> updateUserRole(String token, String id, String role) async {
    final response = await client.put(
      Uri.parse('$baseUrl/user/$id/role'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: json.encode({'role': role}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update user role');
    }
  }
} 