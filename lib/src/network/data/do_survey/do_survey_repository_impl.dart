import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/data/do_survey/do_survey_repository.dart';
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

  Future<List<String>> fetchUserDoingSurveyId(String userId) async {
    List<String> list = [];

    var value = await ref
        .where(DoSurveyCollection.fieldUserId, isEqualTo: userId)
        .get();
    for (var doc in value.docs) {
      var surveyId = doc.data()[DoSurveyCollection.fieldSurveyId];
      if (surveyId != null) {
        list.add(surveyId);
      }
    }
    return list;
  }
}
