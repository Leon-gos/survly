import 'package:survly/src/network/model/user/user.dart';
import 'package:survly/src/network/model/user_base/user_base.dart';

abstract class UserRepository {
  Future<UserBase?> fetchUserByEmail(String email);

  Future<User?> fetchUserById(String userId);
}
