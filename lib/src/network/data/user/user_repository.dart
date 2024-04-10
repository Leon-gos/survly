import 'package:survly/src/network/model/user_base/user_base.dart';

abstract class UserRepository {
  Future<UserBase?> getUserByEmail(String email);
}
