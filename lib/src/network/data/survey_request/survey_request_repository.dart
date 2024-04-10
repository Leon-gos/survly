import 'package:survly/src/network/model/survey_request/survey_request.dart';

abstract class SurveyRequestRepository {
  Future<List<SurveyRequest>> fetchSurveyRequest(String surveyId);
}
