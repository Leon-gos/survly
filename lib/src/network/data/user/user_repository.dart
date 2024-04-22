import 'package:survly/src/network/model/user/user.dart';
import 'package:survly/src/network/model/user_base/user_base.dart';

abstract class UserRepository {
  Future<UserBase?> fetchUserByEmail(String email);
  Future<User?> fetchUserById(String userId);
  Future<List<User>> fetchAllUser();
  Future<List<User>> fetchFirstPageUser();
  Future<List<User>> fetchNextPageUser({required String lastUserId});
  Future<void> createUser(User userInfo);
  Future<bool> checkEmailExisted(String email);
  Future<void> updateUserProfile(UserBase userBase);
  Future<void> updateUserBalance(String userId, int cost);
}
