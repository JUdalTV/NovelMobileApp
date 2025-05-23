// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/main.dart';
import 'package:frontend/data/datasources/novel_remote_data_source.dart';
import 'package:frontend/data/datasources/novel_local_data_source.dart';
import 'package:frontend/data/repositories/novel_repository_impl.dart';
import 'package:frontend/data/repositories/chapter_repository_impl.dart';
import 'package:frontend/domain/repositories/novel_repository.dart';
import 'package:frontend/domain/repositories/chapter_repository.dart';
import 'package:frontend/domain/entities/user.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/domain/usecases/signin.dart';
import 'package:frontend/domain/usecases/signup.dart';
import 'package:frontend/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

// Mock repository for test
class TestAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    return Right(User(id: '1', email: 'test@example.com', username: 'TestUser'));
  }

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    return Right(User(id: '1', email: email, username: 'TestUser'));
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    return Right(User(id: '1', email: email, username: name));
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return const Right(null);
  }
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Khởi tạo repository thật
    final sharedPreferences = await SharedPreferences.getInstance();
    final novelRemoteDataSource = NovelRemoteDataSourceImpl(
      baseUrl: 'http://localhost:5000/api', // Đổi thành baseUrl backend thật nếu cần
      client: http.Client(),
    );
    final novelLocalDataSource = NovelLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    );
    final novelRepository = NovelRepositoryImpl(
      remoteDataSource: novelRemoteDataSource,
      localDataSource: novelLocalDataSource,
    );
    
    // Khởi tạo Chapter Repository
    final chapterRepository = ChapterRepositoryImpl(
      remoteDataSource: novelRemoteDataSource,
      localDataSource: novelLocalDataSource,
    );

    // Khởi tạo Auth Repository và Use Cases
    final authRepository = TestAuthRepository();
    final signIn = SignIn(authRepository);
    final signUp = SignUp(authRepository);

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      novelRepository: novelRepository,
      chapterRepository: chapterRepository,
      sharedPreferences: sharedPreferences,
      signIn: signIn,
      signUp: signUp,
    ));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
