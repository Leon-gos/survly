import 'package:survly/src/network/data/answer_option/answer_option_repository_impl.dart';
import 'package:survly/src/network/data/answer_question/answer_question_repository_impl.dart';
import 'package:survly/src/network/data/authentication/authentication_repository_impl.dart';
import 'package:survly/src/local/secure_storage/authentication/authentication_repository_impl.dart'
    as authentication_local;
import 'package:survly/src/network/data/do_survey/do_survey_repository_impl.dart';
import 'package:survly/src/network/data/question/question_repository_impl.dart';
import 'package:survly/src/network/data/survey/survey_repository_impl.dart';
import 'package:survly/src/network/data/survey_request/survey_request_repository_impl.dart';
import 'package:survly/src/network/data/user/user_repository_impl.dart';

class DomainManager {
  factory DomainManager() {
    _internal ??= DomainManager._();
    return _internal!;
  }
  DomainManager._();
  static DomainManager? _internal;

  final authentication = AuthenticationRepositoryImpl();
  final authenticationLocal =
      authentication_local.AuthenticationRepositoryImpl();
  final user = UserRepositoryImpl();
  final survey = SurveyRepositoryImpl();
  final question = QuestionRepositoryImpl();
  final surveyRequest = SurveyRequestRepositoryImpl();
  final doSurvey = DoSurveyRepositoryImpl();
  final answerQuestion = AnswerQuestionRepositoryImpl();
  final answerOption = AnswerOptionRepositoryImpl();
}
