import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rarolabs/src/utils/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String _baseUrl = "https://private-f3f687-tiagodutra.apiary-mock.com";

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<String> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    } else {
      throw ServerException('Failed to login: ${response.body}');
    }
  }
}
