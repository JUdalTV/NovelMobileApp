import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'core/constants/app_constants.dart';
import 'core/network/network_info.dart';
import 'data/datasources/cloud/fire_store_data_source.dart';
import 'data/datasources/local/auth_local_data_source.dart';
import 'data/datasources/remote/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/signin.dart';
import 'domain/usecases/signup.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'data/datasources/novel_local_data_source.dart';
import 'data/datasources/novel_remote_data_source.dart';
import 'data/repositories/novel_repository_impl.dart';
import 'domain/repositories/novel_repository.dart';
import 'presentation/blocs/navigation/navigation_bloc.dart';
import 'data/repositories/chapter_repository_impl.dart';
import 'domain/repositories/chapter_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Authentication
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signIn: sl(),
      signUp: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      firestoreDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => NodeAuthRemoteDataSource(
      client: sl(),
      baseUrl: AppConstants.API_BASE_URL,
    ),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  sl.registerLazySingleton<FirestoreDataSource>(
    () => FirestoreDataSource(FirebaseFirestore.instance),
  );

  //! Features - Novel
  // Bloc
  sl.registerFactory(() => NavigationBloc());

  // Repository
  sl.registerLazySingleton<NovelRepository>(
    () => NovelRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  
  sl.registerLazySingleton<ChapterRepository>(
    () => ChapterRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NovelRemoteDataSource>(
    () => NovelRemoteDataSourceImpl(
      baseUrl: AppConstants.API_BASE_URL,
      client: sl(),
    ),
  );

  sl.registerLazySingleton<NovelLocalDataSource>(
    () => NovelLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  // Configure Dio
  sl.registerLazySingleton(() => Dio(BaseOptions(
        baseUrl: AppConstants.API_BASE_URL,
        connectTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
        receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      )));
}