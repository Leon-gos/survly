import 'package:survly/src/local/model/login_info.dart';

abstract class AuthenticationRepository {
  Future<void> storeLoginInfo (LoginInfo loginInfo);

  Future<LoginInfo?> readLoginInfo ();
}