import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/data/do_survey/do_survey_repository.dart';
import 'package:survly/src/network/data/file/file_data.dart';
import 'package:survly/src/network/data/user/user_repository_impl.dart';
import 'package:survly/src/network/model/do_survey/do_survey.dart';

class DoSurveyRepositoryImpl implements DoSurveyRepository {
  final ref = FirebaseFirestore.instance.collection(
    DoSurveyCollection.collectionName,
  );

  @override
  Future<int> countDoSurvey({
    required String userId,
    required DoSurveyStatus status,
  }) async {
    var value = await ref
        .where(DoSurveyCollection.fieldUserId, isEqualTo: userId)
        .where(DoSurveyCollection.fieldStatus, isEqualTo: status.value)
        .get();
    return value.size;
  }

  @override
  Future<void> updateCurrentLocation(DoSurvey doSurvey) async {
    await ref.doc(doSurvey.doSurveyId).update({
      DoSurveyCollection.fieldCurrentLat: doSurvey.currentLat,
      DoSurveyCollection.fieldCurrentLng: doSurvey.currentLng,
    });
  }

  @override
  Future<void> updateDoSurvey(DoSurvey doSurvey, String photoLocalPath) async {
    try {
      if (photoLocalPath != "") {
        doSurvey.photoOutlet = await FileData.instance().uploadFileImage(
          filePath: photoLocalPath,
          fileKey: doSurvey.genPhotoOutletFileKey(),
        );
      }
      await ref.doc(doSurvey.doSurveyId).update(doSurvey.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateDoSurveyStatus(
      String doSurveyId, DoSurveyStatus status) async {
    try {
      await ref.doc(doSurveyId).update({
        DoSurveyCollection.fieldStatus: status.value,
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> getDoSurveySnapshot(
    DoSurvey doSurvey,
  ) {
    return ref.doc(doSurvey.doSurveyId).snapshots();
  }

  @override
  Future<DoSurvey> getDoSurvey(String doSurveyId) async {
    var value = await ref.doc(doSurveyId).get();
    if (value.data() != null) {
      var doSurvey = DoSurvey.fromMap(value.data()!);
      doSurvey.doSurveyId = value.id;
      return doSurvey;
    }
    throw Exception("${S.text.errorDoSurveyNotFound}: $doSurveyId");
  }

  @override
  Future<List<String>> fetchUserDoingSurveyId(String userId) async {
    List<String> list = [];

    var value = await ref
        .where(DoSurveyCollection.fieldUserId, isEqualTo: userId)
        .where(
          DoSurveyCollection.fieldStatus,
          isEqualTo: DoSurveyStatus.doing.value,
        )
        .get();
    for (var doc in value.docs) {
      var surveyId = doc.data()[DoSurveyCollection.fieldSurveyId];
      if (surveyId != null) {
        list.add(surveyId);
      }
    }
    return list;
  }

  @override
  Future<DoSurvey?> fetchDoSurveyBySurveyAndUser({
    required String surveyId,
    required String userId,
  }) async {
    var value = await ref
        .where(DoSurveyCollection.fieldSurveyId, isEqualTo: surveyId)
        .where(DoSurveyCollection.fieldUserId, isEqualTo: userId)
        .get();
    if (value.docs.length == 1) {
      return DoSurvey.fromMap({
        ...value.docs[0].data(),
        DoSurveyCollection.fieldDoSurveyId: value.docs[0].id,
      });
    }
    return null;
  }

  @override
  Future<void> submitDoSurvey(DoSurvey doSurvey) async {
    try {
      await ref.doc(doSurvey.doSurveyId).update({
        DoSurveyCollection.fieldStatus: DoSurveyStatus.submitted.value,
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<DoSurvey>> fetchDoSurveyList(String surveyId) async {
    List<DoSurvey> list = [];
    final userRepo = UserRepositoryImpl();

    var value = await ref
        .where(DoSurveyCollection.fieldSurveyId, isEqualTo: surveyId)
        .get();

    for (var doc in value.docs) {
      var doSurvey = DoSurvey.fromMap(doc.data());
      doSurvey.user = await userRepo.fetchUserById(doSurvey.userId);
      list.add(doSurvey);
    }

    return list;
  }
}
