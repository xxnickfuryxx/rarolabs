import 'package:rarolabs/src/domain/entities/user.dart';
import 'package:rarolabs/src/domain/repositories/user_repository.dart';

class GetUsersUseCase {
  final UserRepository repository;
  GetUsersUseCase(this.repository);

  Future<List<User>> call({required int page}) {
    return repository.getUsers(page: page);
  }
}