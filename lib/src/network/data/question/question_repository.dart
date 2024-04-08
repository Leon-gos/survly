import 'package:survly/src/network/model/question/question.dart';

abstract class QuestionRepository {
  Future<void> createQuestion(Question question);
}
