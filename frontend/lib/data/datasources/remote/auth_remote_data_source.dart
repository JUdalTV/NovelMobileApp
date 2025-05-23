import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/user_model.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String username, String email, String password);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
}

class NodeAuthRemoteDataSource implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  String? _token;

  NodeAuthRemoteDataSource({
    required this.client,
    required this.baseUrl,
  });

  String? get token => _token;

  @override
  Future<UserModel> signIn(String email, String password) async {
    print('Đăng nhập với email: $email, password: $password');
    print('API URL: $baseUrl/auth/login');
    
    try {
      final Map<String, dynamic> data = {
        'email': email,
        'password': password,
      };
      
      final String encodedBody = json.encode(data);
      print('Request body: $encodedBody');
      
      // Create a custom request to have more control
      final request = http.Request('POST', Uri.parse('$baseUrl/auth/login'));
      
      // Set headers properly
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      
      // Set the body
      request.body = encodedBody;
      
      // Send the request and get a streamed response
      final streamedResponse = await client.send(request);
      
      // Convert to a regular response
      final response = await http.Response.fromStream(streamedResponse);
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        _token = jsonResponse['token'];
        return UserModel.fromJson(jsonResponse['user']);
      } else if (response.statusCode == 401) {
        throw InvalidCredentialsException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      print('Lỗi khi đăng nhập: $e');
      throw ServerException();
    }
  }

  @override
  Future<UserModel> signUp(String username, String email, String password) async {
    print('Đăng ký với username: $username, email: $email, password: $password');
    try {
      // Create a custom request
      final request = http.Request('POST', Uri.parse('$baseUrl/auth/register'));
      
      // Set headers properly
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      
      // Set the body
      request.body = json.encode({
        'username': username,
        'email': email,
        'password': password,
      });
      
      // Send the request and get a streamed response
      final streamedResponse = await client.send(request);
      
      // Convert to a regular response
      final response = await http.Response.fromStream(streamedResponse);
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        _token = jsonResponse['token'];
        return UserModel.fromJson(jsonResponse['user']);
      } else if (response.statusCode == 409) {
        throw EmailAlreadyInUseException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      print('Lỗi khi đăng ký: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> signOut() async {
    _token = null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    if (_token == null) return null;

    try {
      final response = await client.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return UserModel.fromJson(jsonResponse['user']);
      } else if (response.statusCode == 401) {
        _token = null;
        return null;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}