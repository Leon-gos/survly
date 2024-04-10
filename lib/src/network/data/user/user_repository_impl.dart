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
  Future<UserBase?> getUserByEmail(String email) async {
    try {
      var value =
          await ref.where(UserCollection.fieldEmail, isEqualTo: email).get();
      var docData = value.docs[0].data();
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
}
