import 'package:survly/src/network/model/survey/survey.dart';

abstract class SurveyRepository {
  Future<List<Survey>> fetchFirstPageSurvey();
  Future<List<Survey>> fetchMoreSurvey({required Survey lastSurvey});
  Future<void> createSurvey({
    required Survey survey,
    required String fileLocalPath,
  });
}
