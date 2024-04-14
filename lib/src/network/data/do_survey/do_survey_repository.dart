import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survly/src/network/model/do_survey/do_survey.dart';

abstract class DoSurveyRepository {
  Future<int> countDoSurvey({
    required String userId,
    required DoSurveyStatus status,
  });
  Future<void> updateCurrentLocation(DoSurvey doSurvey);
  Stream<DocumentSnapshot<Map<String, dynamic>>> getDoSurveySnapshot(
    DoSurvey doSurvey,
  );
  Future<DoSurvey> getDoSurvey(String doSurveyId);
}
