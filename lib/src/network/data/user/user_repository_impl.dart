import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/network/data/do_survey/do_survey_repository_impl.dart';
import 'package:survly/src/network/data/user/user_repository.dart';
import 'package:survly/src/network/model/admin/admin.dart';
import 'package:survly/src/network/model/do_survey/do_survey.dart';
import 'package:survly/src/network/model/user/user.dart';
import 'package:survly/src/network/model/user_base/user_base.dart';

class UserRepositoryImpl implements UserRepository {
  final ref =
      FirebaseFirestore.instance.collection(UserCollection.collectionName);

  static const int limitUserPage = 20;

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
        var user = User.fromMap(docData);
        var doSurveyRepo = DoSurveyRepositoryImpl();
        user.countDoing = await doSurveyRepo.countDoSurvey(
            userId: user.id, status: DoSurveyStatus.doing);
        user.countDone = await doSurveyRepo.countDoSurvey(
            userId: user.id, status: DoSurveyStatus.approved);
        return user;
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

  @override
  Future<List<User>> fetchAllUser() async {
    var doSurveyRepo = DoSurveyRepositoryImpl();
    List<User> list = [];
    var value = await ref
        .where(UserCollection.fieldRole, isEqualTo: UserBase.roleUser)
        .get();
    for (var doc in value.docs) {
      var user = User.fromMap(doc.data());
      user.countDoing = await doSurveyRepo.countDoSurvey(
          userId: doc.id, status: DoSurveyStatus.doing);
      user.countDone = await doSurveyRepo.countDoSurvey(
          userId: doc.id, status: DoSurveyStatus.approved);
      list.add(user);
    }

    return list;
  }

  @override
  Future<List<User>> fetchFirstPageUser() async {
    var doSurveyRepo = DoSurveyRepositoryImpl();
    List<User> list = [];
    var value = await ref
        .where(UserCollection.fieldRole, isEqualTo: UserBase.roleUser)
        .limit(limitUserPage)
        .get();
    for (var doc in value.docs) {
      var user = User.fromMap({
        ...doc.data(),
        UserCollection.fieldUserId: doc.id,
      });
      user.countDoing = await doSurveyRepo.countDoSurvey(
          userId: doc.id, status: DoSurveyStatus.doing);
      user.countDone = await doSurveyRepo.countDoSurvey(
          userId: doc.id, status: DoSurveyStatus.approved);
      list.add(user);
    }

    return list;
  }

  @override
  Future<List<User>> fetchNextPageUser({required String lastUserId}) async {
    var doSurveyRepo = DoSurveyRepositoryImpl();
    List<User> list = [];
    var lastDoc = await ref.doc(lastUserId).get();
    var value = await ref
        .where(UserCollection.fieldRole, isEqualTo: UserBase.roleUser)
        .startAfterDocument(lastDoc)
        .limit(limitUserPage)
        .get();
    for (var doc in value.docs) {
      var user = User.fromMap({
        ...doc.data(),
        UserCollection.fieldUserId: doc.id,
      });
      user.countDoing = await doSurveyRepo.countDoSurvey(
          userId: doc.id, status: DoSurveyStatus.doing);
      user.countDone = await doSurveyRepo.countDoSurvey(
          userId: doc.id, status: DoSurveyStatus.approved);
      list.add(user);
    }

    return list;
  }

  @override
  Future<void> createUser(User user) async {
    try {
      if (await checkEmailExisted(user.email)) {
        return;
      }
      var value = await ref.add({});
      ref.doc(value.id).set(user.toMap());
    } catch (e) {
      Logger().e("Create user error", error: e);
    }
  }

  @override
  Future<bool> checkEmailExisted(String email) async {
    var value = await ref
        .where(
          UserCollection.fieldEmail,
          isEqualTo: email,
        )
        .get();
    return value.docs.isNotEmpty;
  }

  @override
  Future<void> updateUserProfile(UserBase userBase) async {
    try {
      if (userBase.role == UserBase.roleUser) {
        final user = userBase as User;
        await ref.doc(user.id).update(user.toMap());
      } else if (userBase.role == UserBase.roleAdmin) {
        final admin = userBase as Admin;
        await ref.doc(admin.id).update(admin.toMap());
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserBalance(String userId, int cost) async {
    try {
      var value = await ref.doc(userId).get();
      await ref.doc(userId).update({
        UserCollection.fieldBalance:
            value.data()?[UserCollection.fieldBalance] + cost,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserNotiToken(String userId, String token) async {
    await ref.doc(userId).update({
      UserCollection.fieldFcmToken: token,
    });
  }

  Future<String?> fetchUserFcmToken(String userId) async {
    var value = await ref.doc(userId).get();
    return value.data()?[UserCollection.fieldFcmToken];
  }
}
