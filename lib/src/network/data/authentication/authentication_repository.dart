abstract class AuthenticationRepository {
  Future<void> signUpEmailPassword(String email, String password);
  Future<void> loginWithEmailPassword(String email, String password);
  Future<void> loginWithGoogle();
  Future<void> logout();
}