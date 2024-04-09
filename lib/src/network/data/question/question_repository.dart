import 'package:survly/src/network/model/question/question.dart';

abstract class QuestionRepository {
  Future<void> createQuestion(Question question);
  Future<void> deleteAllQuestionOfSurvey(String surveyId);
  Future<List<Question>> fetchAllQuestionOfSurvey(String surveyId);
}
