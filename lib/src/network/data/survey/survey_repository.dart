import 'package:survly/src/network/model/survey/survey.dart';

abstract class SurveyRepository {
  Future<List<Survey>> fetchAllSurvey();
  Future<List<Survey>> fetchMoreSurvey({required Survey lastSurvey});
  Future<void> createSurvey(Survey survey);
}
