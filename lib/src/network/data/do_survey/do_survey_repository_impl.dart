import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
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
}
