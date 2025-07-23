import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rarolabs/src/data/models/user_model.dart';
import 'package:rarolabs/src/utils/exceptions.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers({required int page});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  final String _baseUrl = "https://reqres.in/api";

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<List<UserModel>> getUsers({required int page}) async {
    final response = await client.get(Uri.parse(
        page == 1 ? '$_baseUrl/users' : '$_baseUrl/users?page=$page'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> userList = data['data'];
      return userList.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw ServerException('Failed to load users');
    }
  }
}
