import 'package:survly/src/network/model/do_survey/do_survey.dart';

abstract class DoSurveyRepository {
  Future<int> countDoSurvey({
    required String userId,
    required DoSurveyStatus status,
  });
}
