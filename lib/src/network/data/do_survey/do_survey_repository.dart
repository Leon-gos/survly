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
  Future<List<String>> fetchUserDoingSurveyId(String userId);
  Future<DoSurvey?> fetchDoSurveyBySurveyAndUser({
    required String surveyId,
    required String userId,
  });
  Future<void> updateDoSurvey(DoSurvey doSurvey, String photoLocalPath);
  Future<void> submitDoSurvey(DoSurvey doSurvey);
  Future<List<DoSurvey>> fetchDoSurveyList(String surveyId);
  Future<void> updateDoSurveyStatus(String doSurveyId, DoSurveyStatus status);
  Future<DoSurvey?> fetchDoSurveyById(String doSurveyId);
  Future<List<DoSurvey>> fetchUserJoinedSurvey(String userId);
}
