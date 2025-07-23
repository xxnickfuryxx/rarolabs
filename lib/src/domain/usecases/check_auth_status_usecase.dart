import 'package:rarolabs/src/domain/repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;
  CheckAuthStatusUseCase(this.repository);

  Future<bool> call() {
    return repository.isAuthenticated();
  }
}