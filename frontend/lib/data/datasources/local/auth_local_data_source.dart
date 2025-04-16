import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/failures.dart';
import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  /// Lấy thông tin người dùng đã cache
  ///
  /// Ném [CacheException] nếu không có dữ liệu
  Future<UserModel> getLastUser();

  /// Cache thông tin người dùng
  Future<void> cacheUser(UserModel userToCache);

  /// Xóa thông tin người dùng đã cache
  Future<void> clearUser();
}

const CACHED_USER_KEY = 'CACHED_USER';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel> getLastUser() {
    final jsonString = sharedPreferences.getString(CACHED_USER_KEY);
    if (jsonString != null) {
      return Future.value(UserModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheFailure();
    }
  }

  @override
  Future<void> cacheUser(UserModel userToCache) {
    return sharedPreferences.setString(
      CACHED_USER_KEY,
      json.encode(userToCache.toJson()),
    );
  }

  @override
  Future<void> clearUser() {
    return sharedPreferences.remove(CACHED_USER_KEY);
  }
}