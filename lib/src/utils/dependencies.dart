import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:rarolabs/src/data/datasources/auth_local_datasource.dart';
import 'package:rarolabs/src/data/datasources/auth_remote_datasource.dart';
import 'package:rarolabs/src/data/datasources/user_local_datasource.dart';
import 'package:rarolabs/src/data/datasources/user_remote_datasource.dart';
import 'package:rarolabs/src/data/repositories/auth_repository_impl.dart';
import 'package:rarolabs/src/data/repositories/user_repository_impl.dart';
import 'package:rarolabs/src/domain/repositories/auth_repository.dart';
import 'package:rarolabs/src/domain/repositories/user_repository.dart';
import 'package:rarolabs/src/domain/usecases/get_users_usecase.dart';
import 'package:rarolabs/src/domain/usecases/login_usecase.dart';
import 'package:rarolabs/src/domain/usecases/check_auth_status_usecase.dart';
import 'package:rarolabs/src/domain/usecases/logout_usecase.dart';
import 'package:rarolabs/src/view/pages/feed/feed_viewmodel.dart';
import 'package:rarolabs/src/view/pages/login/login_viewmodel.dart';
import 'package:rarolabs/src/view/pages/user_list/user_list_viewmodel.dart';
import 'package:rarolabs/src/view/pages/user_profile/user_profile_viewmodel.dart';

final getIt = GetIt.instance;

/// Sets up the dependency injection container.
Future<void> setupDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton(sharedPreferences);
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => Connectivity());

  // DataSources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: getIt()));
  getIt.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sharedPreferences: getIt()));
  getIt.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(client: getIt()));
  getIt.registerLazySingleton<UserLocalDataSource>(
      () => UserLocalDataSourceImpl(sharedPreferences: getIt()));

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
      ));
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
        connectivity: getIt(),
      ));

  // UseCases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => GetUsersUseCase(getIt()));
  getIt.registerLazySingleton(() => CheckAuthStatusUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));

  // ViewModels
  getIt.registerFactory(() => LoginViewModel(getIt()));
  getIt.registerFactory(() => UserListViewModel(getIt(), getIt()));
  getIt.registerFactory(() => UserProfileViewModel());
  getIt.registerFactory(() => FeedViewModel());
}
