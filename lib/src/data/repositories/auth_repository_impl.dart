import 'package:rarolabs/src/domain/repositories/auth_repository.dart';
import 'package:rarolabs/src/data/datasources/auth_remote_datasource.dart';
import 'package:rarolabs/src/data/datasources/auth_local_datasource.dart';
import 'package:rarolabs/src/utils/exceptions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> login(String email, String password) async {
    try {
      final token = await remoteDataSource.login(email, password);
      await localDataSource.cacheToken(token);
    } on ServerException catch (e) {
      throw Exception(e.message);
    }
  }
  
  @override
  Future<bool> isAuthenticated() async {
    final token = await localDataSource.getToken();
    return token != null;
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearToken();
  }
}