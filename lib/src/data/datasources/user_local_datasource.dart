import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rarolabs/src/data/models/user_model.dart';
import 'package:rarolabs/src/utils/exceptions.dart';

abstract class UserLocalDataSource {
  Future<List<UserModel>> getLastUsers();
  Future<void> cacheUsers(List<UserModel> users);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const _cachedUsersKey = 'CACHED_USERS';

  UserLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUsers(List<UserModel> users) {
    final List<String> userListJson =
        users.map((user) => jsonEncode(user.toJson())).toList();
    return sharedPreferences.setStringList(_cachedUsersKey, userListJson);
  }

  @override
  Future<List<UserModel>> getLastUsers() {
    final jsonStringList = sharedPreferences.getStringList(_cachedUsersKey);
    if (jsonStringList != null) {
      final users = jsonStringList
          .map((jsonString) => UserModel.fromJson(jsonDecode(jsonString)))
          .toList();
      return Future.value(users);
    } else {
      throw CacheException('No users found in cache');
    }
  }
}