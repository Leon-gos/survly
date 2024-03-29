abstract class AuthenticationRepository {
  Future<void> signUpEmailPassword(String emailAddress, String password);
  Future<void> loginWithEmailPassword();
  Future<void> loginWithGoogle();
  Future<void> logout();
}