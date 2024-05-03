import 'package:flutter_geo_hash/geohash.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/survey/survey.dart';

abstract class SurveyRepository {
  Future<List<Survey>> fetchFirstPageSurvey();
  Future<List<Survey>> fetchMoreSurvey({required Survey lastSurvey});
  Future<void> createSurvey({
    required Survey survey,
    required String fileLocalPath,
    required List<Question> questionList,
  });

  Future<void> updateSurvey({
    required Survey survey,
    required String fileLocalPath,
    required List<Question> questionList,
  });

  Future<Survey?> fetchSurveyById(String surveyId);

  Future<void> changeSurveyStatus(String surveyId, String newStatus);
  Future<List<Survey>> fetchFirstPageExploreSurvey();
  Future<List<Survey>> fetchMoreExploreSurvey({required Survey lastSurvey});
  Future<List<Survey>> fetchFirstPageExploreSurveyNearBy({
    required double km,
    required GeoPoint geoPoint,
  });
  Future<List<Survey>> fetchMoreExploreSurveyNearBy({
    required double km,
    required GeoPoint geoPoint,
    required Survey lastSurvey,
  });
  Future<void> increaseSurveyRespondentNum(String surveyId);
  Future<List<Survey>> fetchAdminSurveyList(String? adminId);
}
