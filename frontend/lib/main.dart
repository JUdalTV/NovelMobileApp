import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend/presentation/blocs/auth/auth_state.dart';
import 'package:frontend/presentation/pages/profile/profile_screen.dart';
import 'package:frontend/presentation/pages/search/search.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/navigation/navigation_bloc.dart';
import 'presentation/pages/auth/signin.dart';
import 'presentation/pages/main_screen.dart';
import 'injection_container.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'data/datasources/novel_remote_data_source.dart';
import 'data/datasources/novel_local_data_source.dart';
import 'data/repositories/novel_repository_impl.dart';
import 'data/repositories/chapter_repository_impl.dart';
import 'domain/repositories/novel_repository.dart';
import 'domain/repositories/chapter_repository.dart';
import 'presentation/pages/home/home.dart';
import 'core/constants/app_constants.dart';
import 'package:provider/provider.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'config/api_config.dart';
import 'package:dartz/dartz.dart';
import 'domain/entities/user.dart';
import 'core/errors/failures.dart';
import 'domain/usecases/signin.dart';
import 'domain/usecases/signup.dart';
import 'domain/repositories/auth_repository.dart';

// Mock repository for authentication
class MockAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    return Right(User(id: '1', email: 'user@test.com', username: 'TestUser'));
  }

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    return Right(User(id: '1', email: email, username: 'User'));
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  final httpClient = http.Client();

  // Initialize data sources and repositories
  final novelLocalDataSource = NovelLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  final novelRemoteDataSource = NovelRemoteDataSourceImpl(
    baseUrl: ApiConfig.apiBaseUrl,
    client: httpClient,
  );
  final novelRepository = NovelRepositoryImpl(
    remoteDataSource: novelRemoteDataSource,
    localDataSource: novelLocalDataSource,
  );
  
  final chapterRepository = ChapterRepositoryImpl(
    remoteDataSource: novelRemoteDataSource,
    localDataSource: novelLocalDataSource,
  );

  // Create auth repository and use cases
  final mockAuthRepository = MockAuthRepository();
  final signIn = SignIn(mockAuthRepository);
  final signUp = SignUp(mockAuthRepository);

  await di.init();
  runApp(MyApp(
    sharedPreferences: sharedPreferences,
    novelRepository: novelRepository,
    chapterRepository: chapterRepository,
    signIn: signIn,
    signUp: signUp,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final NovelRepository novelRepository;
  final ChapterRepository chapterRepository;
  final SignIn signIn;
  final SignUp signUp;

  const MyApp({
    Key? key,
    required this.sharedPreferences,
    required this.novelRepository,
    required this.chapterRepository,
    required this.signIn,
    required this.signUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            signIn: signIn,
            signUp: signUp,
          )..add(AppStarted()),
        ),
        BlocProvider<NavigationBloc>(
          create: (context) => NavigationBloc(),
        ),
        Provider<NovelRepository>.value(value: novelRepository),
      ],
      child: MaterialApp(
        title: 'Tu Tiên',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xff078fff),
          fontFamily: 'Inter',
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        supportedLocales: const [
          Locale('vi', 'VN'),
          Locale('en', 'US'), // Fallback
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('vi', 'VN'),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return MainScreen(novelRepository: novelRepository);
            } else if (state is Unauthenticated) {
              return const SigninScreen();
            } else {
              // Loading state
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
}
