abstract class AuthRepository {
  Future<void> login(String email, String password);
  Future<bool> isAuthenticated();
  Future<void> logout();
}
