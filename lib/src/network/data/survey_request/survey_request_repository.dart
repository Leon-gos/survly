import 'package:survly/src/network/model/survey_request/survey_request.dart';

abstract class SurveyRequestRepository {
  Future<List<SurveyRequest>> fetchAllSurveyRequest();

  Future<List<SurveyRequest>> fetchRequestOfSurvey(String surveyId);

  Future<void> responseSurveyRequest({
    required String requestId,
    required SurveyRequestStatus status,
  });
}
