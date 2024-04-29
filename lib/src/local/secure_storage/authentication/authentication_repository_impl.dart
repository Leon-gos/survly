import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:survly/src/config/constants/timeout.dart';
import 'package:survly/src/local/model/login_info.dart';
import 'package:survly/src/local/secure_storage/authentication/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final _storage = const FlutterSecureStorage();
  static const keyEmail = "USER_EMAIL";
  static const keyPassword = "USER_PASSWORD";

  @override
  Future<LoginInfo?> readLoginInfo() async {
    var email = await _storage
        .read(key: keyEmail)
        .timeout(const Duration(seconds: Timeout.readLocalStorageTimeout));
    var password = await _storage
        .read(key: keyPassword)
        .timeout(const Duration(seconds: Timeout.readLocalStorageTimeout));
    if (email != null && password != null) {
      return LoginInfo(email: email, password: password);
    }
    return null;
  }

  @override
  Future<void> storeLoginInfo(LoginInfo loginInfo) async {
    await _storage.write(key: keyEmail, value: loginInfo.email);
    await _storage.write(key: keyPassword, value: loginInfo.password);
  }

  @override
  Future<void> clearLoginInfo() async {
    await _storage.deleteAll();
  }
}