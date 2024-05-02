import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/network/data/authentication/authentication_repository.dart';
import 'package:survly/src/network/data/user/user_repository_impl.dart';
import 'package:survly/src/network/model/user/user.dart' as my_user;

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  @override
  Future<void> loginWithEmailPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Logger().d('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Logger().d('Wrong password provided for that user.');
      }
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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await UserRepositoryImpl().createUser(my_user.User.newUser(
        email: email,
        fullname: fullname,
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw (Exception("The password provided is too weak."));
      } else if (e.code == 'email-already-in-use') {
        throw (Exception("The account already exists for that email."));
      }
    } catch (e) {
      rethrow;
    }
  }
}
