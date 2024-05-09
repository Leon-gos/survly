import 'package:survly/src/network/model/notification/noti_do_survey.dart';

abstract class NotiDoSurveyRepository {
  Future<void> createNotiDoSurvey(NotiDoSurvey notiDoSurvey);
  Future<NotiDoSurvey?> fetchNotiDoSurveyById(String notiDoSurveyId);
  Future<NotiDoSurvey?> fetchNotiDoSurveyByNotiId(String notiId);
}
