import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import '../../../../core/errors/failures.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Gọi API đăng nhập
  ///
  /// Ném [ServerException] nếu có lỗi xảy ra
  Future<UserModel> signIn(String username, String password);

  /// Gọi API đăng ký
  ///
  /// Ném [ServerException] nếu có lỗi xảy ra
  Future<UserModel> signUp(String username, String password);

  /// Gọi API xác minh căn cước
  ///
  /// Ném [ServerException] nếu có lỗi xảy ra
  Future<bool> verifyId(String userId, String idImagePath);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://67a70d51510789ef0dfcd43d.mockapi.io/';

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> signIn(String username, String password) async {
    developer.log('===== BẮT ĐẦU ĐĂNG NHẬP =====');
    developer.log('Đang thực hiện đăng nhập với username: $username');

    try {
      final url = '$baseUrl/User';
      developer.log('Đang gọi API đăng nhập: $url');

      developer.log(
          'Sử dụng tìm kiếm theo username và password thay vì endpoint Login');
      // MockAPI thường không có endpoint Login riêng, mà dùng GET với filter
      final loginUrl = Uri.parse('$url?username=$username&password=$password');
      developer.log('URL đầy đủ: $loginUrl');

      final response = await client.get(
        loginUrl,
        headers: {'Content-Type': 'application/json'},
      );

      developer.log(
          'Nhận được response đăng nhập với status code: ${response.statusCode}');
      developer.log('Response header: ${response.headers}');
      developer.log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final List<dynamic> jsonResponse = json.decode(response.body);
          developer.log('Đã parse JSON thành công: $jsonResponse');

          if (jsonResponse.isEmpty) {
            developer
                .log('Không tìm thấy user với thông tin đăng nhập đã cung cấp');
            throw InvalidCredentialsFailure();
          }

          // Lấy user đầu tiên từ danh sách kết quả
          final user = UserModel.fromJson(jsonResponse[0]);
          developer.log('Tạo UserModel thành công: ${user.toString()}');
          return user;
        } catch (e) {
          if (e is InvalidCredentialsFailure) {
            rethrow;
          }
          developer.log('Lỗi khi parse JSON hoặc tạo UserModel: $e', error: e);
          throw ServerFailure();
        }
      } else if (response.statusCode == 401) {
        developer.log('Đăng nhập thất bại: Thông tin đăng nhập không hợp lệ');
        throw InvalidCredentialsFailure();
      } else {
        developer.log(
            'Đăng nhập thất bại: Lỗi server với status code ${response.statusCode}');
        throw ServerFailure();
      }
    } catch (e, stackTrace) {
      if (e is InvalidCredentialsFailure) {
        rethrow;
      }
      developer.log('Có lỗi xảy ra khi đăng nhập: $e',
          error: e, stackTrace: stackTrace);
      throw ServerFailure();
    } finally {
      developer.log('===== KẾT THÚC ĐĂNG NHẬP =====');
    }
  }

  @override
  Future<UserModel> signUp(String username, String password) async {
    developer.log('===== BẮT ĐẦU ĐĂNG KÝ =====');
    developer.log('Đang thực hiện đăng ký với username: $username');

    try {
      // Cần kiểm tra URL của API đăng ký
      // Thay đổi endpoint từ /register thành /User để phù hợp với cấu trúc của mockAPI
      final url = '$baseUrl/User';
      developer.log('Đang gọi API đăng ký: $url');

      final body = json.encode({
        'username': username,
        'password': password,
      });
      developer.log('Body request đăng ký: $body');

      final response = await client.post(
        Uri.parse(url),
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      developer.log(
          'Nhận được response đăng ký với status code: ${response.statusCode}');
      developer.log('Response header: ${response.headers}');
      developer.log('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        try {
          final jsonResponse = json.decode(response.body);
          developer.log('Đã parse JSON thành công: $jsonResponse');
          final user = UserModel.fromJson(jsonResponse);
          developer.log('Tạo UserModel thành công: ${user.toString()}');
          return user;
        } catch (e) {
          developer.log('Lỗi khi parse JSON hoặc tạo UserModel: $e', error: e);
          throw ServerFailure();
        }
      } else if (response.statusCode == 409) {
        developer.log('Đăng ký thất bại: Username đã tồn tại');
        throw UserAlreadyExistsFailure();
      } else {
        developer.log(
            'Đăng ký thất bại: Lỗi server với status code ${response.statusCode}');
        throw ServerFailure();
      }
    } catch (e, stackTrace) {
      developer.log('Có lỗi xảy ra khi đăng ký: $e',
          error: e, stackTrace: stackTrace);
      throw ServerFailure();
    } finally {
      developer.log('===== KẾT THÚC ĐĂNG KÝ =====');
    }
  }

  @override
  Future<bool> verifyId(String userId, String idImagePath) async {
    // Thực hiện upload hình ảnh và xác minh ID
    // Đây là một mẫu đơn giản, cần thêm logic xử lý upload file
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/auth/verify-id'),
        body: json.encode({
          'user_id': userId,
          'id_image_path': idImagePath,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw VerificationFailure();
      }
    } catch (e) {
      throw ServerFailure();
    }
  }
}
