import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/network/data/user/user_repository.dart';
import 'package:survly/src/network/model/admin/admin.dart';
import 'package:survly/src/network/model/user/user.dart';
import 'package:survly/src/network/model/user_base/user_base.dart';

class UserRepositoryImpl implements UserRepository {
  final ref =
      FirebaseFirestore.instance.collection(UserCollection.collectionName);

  @override
  Future<UserBase?> fetchUserByEmail(String email) async {
    try {
      var value =
          await ref.where(UserCollection.fieldEmail, isEqualTo: email).get();
      var docData = value.docs[0].data();
      docData[UserCollection.fieldUserId] = value.docs[0].id;
      if (docData[UserCollection.fieldRole] == UserBase.roleAdmin) {
        return Admin.fromMap(docData);
      } else {
        return User.fromMap(docData);
      }
    } catch (e) {
      Logger().e("Get user info error", error: e);
      rethrow;
    }
  }

  @override
  Future<User?> fetchUserById(String userId) async {
    try {
      var doc = await ref.doc(userId).get();
      return User.fromMap(doc.data()!);
    } catch (e) {
      Logger().e("Error get user by id", error: e);
      rethrow;
    }
  }
}
