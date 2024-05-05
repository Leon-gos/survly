import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/firebase_auth_error.dart';
import 'package:survly/src/network/data/authentication/authentication_repository.dart';
import 'package:survly/src/network/data/user/user_repository_impl.dart';
import 'package:survly/src/network/model/user/user.dart' as my_user;

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  @override
  Future<void> loginWithEmailPassword(String email, String password) async {
    try {
      var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user?.emailVerified != true) {
        throw FirebaseAuthException(code: FirebaseAuthError.emailNotVerified);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserCredential?> loginWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      var userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // create user in database
      await UserRepositoryImpl().createUser(my_user.User.newUser(
        email: userCredential.user!.email!,
        fullname: userCredential.user!.displayName!,
      ));

      return userCredential;
    } catch (e) {
      Logger().e("Login with google error", error: e);
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      Logger().d("sign out");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signUpEmailPassword(
    String email,
    String password,
    String fullname,
  ) async {
    try {
      var credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.sendEmailVerification();
      await UserRepositoryImpl().createUser(my_user.User.newUser(
        email: email,
        fullname: fullname,
      ));
    } catch (e) {
      rethrow;
    }
  }
}
