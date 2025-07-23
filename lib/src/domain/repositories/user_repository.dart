import 'package:rarolabs/src/domain/entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getUsers({required int page});
}