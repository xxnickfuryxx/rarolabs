import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rarolabs/src/domain/entities/user.dart';
import 'package:rarolabs/src/domain/repositories/user_repository.dart';
import 'package:rarolabs/src/data/datasources/user_remote_datasource.dart';
import 'package:rarolabs/src/data/datasources/user_local_datasource.dart';
import 'package:rarolabs/src/utils/exceptions.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final Connectivity connectivity;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  @override
  Future<List<User>> getUsers({required int page}) async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // Offline mode
      try {
        if (page == 1) {
          // Only load from cache for the first page
          return await localDataSource.getLastUsers();
        } else {
          return []; // No pagination in offline mode
        }
      } on CacheException {
        throw Exception('Você está sem internet e sem dados salvos no dispositivo.');
      }
    } else {
      // Online mode
      try {
        final users = await remoteDataSource.getUsers(page: page);
        if (page == 1) {
          // Cache the first page for offline use
          localDataSource.cacheUsers(users);
        }
        return users;
      } on ServerException catch (e) {
        throw Exception(e.message);
      }
    }
  }
}
