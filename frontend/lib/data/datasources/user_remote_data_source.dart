import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/user.dart';

abstract class UserRemoteDataSource {
  Future<User> getCurrentUser();
  Future<User> updateProfile(String username, String? avatar);
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<List<User>> getUsers();
  Future<User> getUserById(String id);
  Future<void> deleteUser(String id);
  Future<void> updateUserRole(String id, String role);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final String baseUrl;
  final http.Client client;

  UserRemoteDataSourceImpl({
    required this.baseUrl,
    required this.client,
  });

  @override
  Future<User> getCurrentUser() async {
    final response = await client.get(Uri.parse('$baseUrl/users/me'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get current user');
    }
  }

  @override
  Future<User> updateProfile(String username, String? avatar) async {
    final response = await client.put(
      Uri.parse('$baseUrl/users/me'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'avatar': avatar,
      }),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update profile');
    }
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    final response = await client.put(
      Uri.parse('$baseUrl/users/me/password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to change password');
    }
  }

  @override
  Future<List<User>> getUsers() async {
    final response = await client.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get users');
    }
  }

  @override
  Future<User> getUserById(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get user');
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    final response = await client.delete(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }

  @override
  Future<void> updateUserRole(String id, String role) async {
    final response = await client.put(
      Uri.parse('$baseUrl/users/$id/role'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'role': role}),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update user role');
    }
  }
} 