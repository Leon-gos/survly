import 'package:survly/src/network/model/question/question.dart';

class QuestionText extends Question {
  String? answer;

  QuestionText({
    super.questionId = "",
    required super.questionIndex,
    super.question = "",
    required super.questionType,
    super.surveyId = "",
    this.answer,
  });
}
